## Some Utilities

### Git Extensions
Two git extenions that should make for easier adding of files to commit.

_Make sure you include these file in your PATH for them to be accesible._

#### git istatus
This method shows the modified files with an index next to their file location.  Works the same as `git status`.
__Usage__

```
> git istatus
Modified Files for Commit:
   1: src/my/file/one.java
   2: src/my/file/two.java
   3: src/my/three.java
   4: conf/main.conf
   5: README.md
```

#### git iadd
This method allows you to add by index (gotten from `git istatus`) the file associated at that index for commit. Works the same as `git add <file_name>`.

__Usage__

`git iadd <index>`

__Example__

```
> git istatus
Modified Files for Commit:
   1: src/my/file/one.java
   2: src/my/file/two.java
   3: src/my/three.java
   4: conf/main.conf
   5: README.md
   
# Add the file at index '2'
> git iadd 2
# Add both files at index '3' and '5'
> git iadd 3,5
```

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
