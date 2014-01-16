## Some Utilities

### quick_mock.rb
Turns a .thrift file into a mock file in .coffee.  Finds all the available structs defined in the .thrift and all the methods used for a interface and creates the methods for that interface and applies the structs as returns where possible.
Requires a delicately formatted thrift file.

#### Usage
```
> ./quick_mock.rb service_name file_name
```

Where service_name is the name of the thrift service you're looking for and file_name is the name of the .thrift file.

It will output the result to the console where you can copy and paste into a file of your needs.
