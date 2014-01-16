#!/usr/bin/env ruby

# Mock A Thrift class quickly

require 'net/http'
require 'csv'

class ThriftStruct
  attr_accessor :name, :components
  def initialize(name=nil)
    @name = name
  end
  def add_component(type, name)
    @components ||= {}
    @components[name] = type
  end
end     

class ThriftMethod
  
  attr_accessor :type, :name
  def initialize(type=nil,name=nil)
    set_name(name)
    set_type(type)
  end
  def set_name(name)
    @name = name
  end
  def set_type(type)
    @type = type
  end
end




# Determine true/false this line is the start of a method we need to take in
def is_method_start_line?(line)
  split_line = line.split(/\ /)
  result = false
  if split_line.length == 2
    if split_line.last[-1] == "("
      result = true
    end
  end
  result
end

def create_method(line)
  split_line = line[0..-2].split /\ /
  _type = split_line.first
  _name = split_line.last
  _method = ThriftMethod.new
  _method.set_name _name
  _method.set_type _type
  _method
end

def create_struct(line)
  split_line = line.strip.split /\ /
  _type = split_line.first
  _name = split_line[1]
  _struct = ThriftStruct.new(_name)
  _struct
end

def create_component_for_struct(line)
  line = line.split(":").last.strip
  line = line.gsub(",",'')
  line.split /\ /
end

def is_method_complete?(line)
  split_line = line.split(/\ /)
  if split_line.include? 'throws'
    return true
  end
  false
end   

def gen_viable_value(type, key)
  if not (key.downcase.index 'uid').nil?
    return "'#{key[0].upcase}-#{(rand*10000).to_i}-TEST'"
  elsif type == 'string'
    if key.downcase.index 'name'
      return "'#{%w(John James Peter Mary Johnson Smith McGuiver Scully Mulder).sample}'"
    elsif key.downcase.index 'email'
      return "'#{%w(John James Peter Mary Johnson Smith McGuiver Scully Mulder).sample + "@isocket.com"}'"
    elsif key.downcase.index 'phone'
      return "'555-238-2312'"
    else
      return "'#{%w(Banana Apple Pear Kiwii Dumpling Pizza Animal Tofu).sample}'"
    end
  else
    return "null"
  end

end

def is_struct_start?(line)
  split_line = line.strip.split /\ /
  (split_line.length == 3) and (split_line.last == "{") and (split_line.first == "struct")
end

def is_struct_complete?(line)
  line.strip == "}"
end   




service = ARGV[0].to_s
file_name = ARGV[1].to_s
output_file = ARGV[2].to_s

inside_service = false
outside_service = false

inside_method = false
inside_struct = false

writable_methods = {}
writable_structs = {}
current_struct_key = nil


# Open the service file for reading
File.open(file_name, 'r') do |file|
  file.each do |line|
    # Strip of beginning and ending spaces
    line = line.strip
    # tokenize the line by spaces
    tokens = line.split(/\ /)
    next if tokens.empty?

    if not inside_service
      if tokens.include? service
        inside_service = true
      end

      if inside_struct
        inside_struct = false if is_struct_complete?(line)
        if inside_struct
          comp = create_component_for_struct line
          curr_struct = writable_structs[current_struct_key]
          curr_struct.add_component comp[0], comp[1]
        end
      else
        inside_struct = is_struct_start?(line)
        if inside_struct
          struct = create_struct(line)
          writable_structs[struct.name] = struct
          current_struct_key = struct.name
        end
      end

    else
      if inside_method
        inside_method = false if is_method_complete?(line)
      else
        # check if we are entering into a method
        inside_method = true if is_method_start_line?(line)
        if inside_method
          meth = create_method(line)
          writable_methods[meth.name] = meth
        end
      end
    end

    if inside_service
      if tokens.include? "}"
        outside_service = true
      end
      if outside_service
        break
      end

      
    end



  end
end

# Now we can write the actual file
tab = "  "
output = []
output << "module.exports = ->"
writable_methods.each_pair do |name, obj|
  output << "#{tab}#{name}: (params) ->"
  obj_type = obj.type

  if obj_type == 'string'
    output << "#{tab}#{tab}params.callback null, 'your-ret-string'"
  elsif obj_type == 'i64'
    output << "#{tab}#{tab}params.callback null, 42"
  elsif obj_type == 'boolean'
    output << "#{tab}#{tab}params.callback null, true"
  else
    thrift_struct = writable_structs[obj_type]
    if not thrift_struct.nil?
      output << "#{tab}#{tab}#{thrift_struct.name.downcase} = "
      thrift_struct.components.each_pair do |component_name, component_type|
        safe_component_name = component_name.gsub(/[^a-zA-Z\:]/,'')
        comp_partial = "#{tab}#{tab}#{tab}#{safe_component_name}:#{tab}"
        comp_partial << gen_viable_value(component_type, component_name)
        output << comp_partial
      end
      output << "#{tab}#{tab}params.callback null, #{thrift_struct.name.downcase}"
    end
  end

  output << "#{tab}"
end

puts output.join("\n")

File.open(output_file, 'w') do |file|
  file.write(output.join("\n"))
end 





