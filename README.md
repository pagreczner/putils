## Some Utilities

### setwebp.sh
Turns on or off the web proxy from the command line.

#### Usage
```
# Turn web proxy on (two methods)
> ./setwebp.sh
> ./setwebp.sh on
```

```
# Turn web proxy off
> ./setwebp.sh off
```

### uq_latest.sh
Makes the most recent order entity visible which had been quarantined.

#### Usage
```
> ./uq_latest.sh
```

### quick_mock.rb
Turns a .thrift file into a mock file in .coffee.  Finds all the available structs defined in the .thrift and all the methods used for a interface and creates the methods for that interface and applies the structs as returns where possible.
Requires a delicately formatted thrift file.

#### Usage
```
> ./quick_mock.rb service_name file_name output_file_name
```

Where service_name is the name of the thrift service you're looking for and file_name is the name of the .thrift file.  output_file_name is the name of the file you want to write the results to.

It will also print out the results to the console.
