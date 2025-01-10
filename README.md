# Jorg
A simple resume generator to take TOML and output pdf.

## Dependencies 
- Common linux tools like `make`
- latexmk
- A recent-enough Mercury compiler (which also means you need a C compiler, probably gcc)

## Installation
Clone `https://github.com/jku20/jorg`. In the root of the directory, type `make`. To run tests, type `make test`.

## Usage
To print help, run
```bash
jorg -h
```

To make a resume pdf, run
```bash
jorg resume.toml -o resume.pdf
```

## TOML Format 
Below is an example file showing all of the supported names in the toml as well as an image of what it renders to.

TODO

## TODOs
- [ ] minimum working product
    - [ ] figure out how general I want to make this
- [ ] migrate from toml.h to something written in mercury or a better C library
