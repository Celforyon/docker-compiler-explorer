# Compiler Explorer

Self-hosted version of https://godbolt.org/

## Usage

### Relevant directories

- /opt: typically add compilers here
- /usr/local/bin: (in the user `PATH`)
- /ce/config: configuration files for Compiler Explorer compilers
- /ce/examples: default and examples files for languages
- /ce/docs: documentations from Compiler Explorer git repository
- /compiler-explorer/lib: languages.js contain the list of supported languages

### /ce/compiler-adapter

Compiler Explorer use a default commandline looking like:
```
-g -o <output> -S <additional flags added by user> <input>
```
which could be impractical for interpreter-like compilers.
This binary currently does this:
- isolates `<input>` and gives it as last argument
- isolates `<output>` and redirects into it using `>`
- removes extra flags `-g`, `-o` and `-S`
- writes a file containing all data after `---` if encountered in commandline, that file is then redirected using `<`

You can use it by creating a symbolic link named `compiler.name`, where `name` is an executable in the `PATH`.