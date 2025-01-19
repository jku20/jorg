# Jorg
A file template tool. Specify file "templates," files with variables in them, and then substitute these variables with text specified in a TOML file.

## Dependencies 
- Common linux tools like `make`
- A recent-enough ROTD build of the Mercury compiler (which also means you need a C compiler, probably gcc)
- glib, (the package glib2-devel on fedora for example), required by the arg parse library colipa.

## Building
Clone `https://github.com/jku20/jorg`. In the root of the directory, type 
```bash
make
```
This will generate the `jorg` binary in the root of the directory.

To run tests, type 
```bash
make test
```

## Usage
To print help, run
```bash
jorg -h
```

To combine templates into an output file, run
```bash
jorg template.toml -o out.txt
```

## TOML Format 
Below is an example file showing all of the supported names in the toml as well as an image of what it renders to.

TODO

## Ideas for the Format
I think the way I want to do this is as follows:
The user makes a toml file which specifies another file as a list of "components". The schema would look like
```toml
[file]
structure = ["header", "body", "repeating", "body", "repeating", "footer"]
path = "generated file path"

[header]
src = "path to template"
variable1_in_template = "value to replace variable with"
variable2_in_template = "value to replace variable with"

[body]
src = "path to template"
variable_in_template = "some value"
repeating_variable_in_template = ["some other value", "yet another value"]

[[repeating]]
src = "path to template"
variable_in_template = "some value"
repeating_variable_in_template = ["some other value", "yet another value"]

[[repeating]]
src = "path to template"
variable_in_template = "some value"
repeating_variable_in_template = ["some other value", "yet another value"]

[footer]
src = "path to template"
variable1_in_template = "value to replace variable with"
variable2_in_template = "value to replace variable with"
```
Not sure the exact semantics yet, but at a high level what's going on is the file is the concatenation of each component. Components each have source templates which contain simple variables, or repeating expressions with variables in them. 

There are normal components which are generated from a source template and variable assignments. There are also array components which let the user specify multiple components using the same name, each of which should be placed one after another. This doesn't make the tool more powerful, but it can help readability in the case of say, a repeating list.
