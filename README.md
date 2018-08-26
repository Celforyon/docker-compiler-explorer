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

### ENV

- PUID: user UID (1000)
- PGID: user GID (1000)
- GCC_MIRROR: URL for GCC releases mirror ("ftp://ftp.uvsq.fr/pub/gcc/")

### /ce/compiler-adapter

Compiler Explorer use a default commandline looking like:
```
-g -o <output> -S <additional flags added by user> <input>
```
which could be impractical for interpreter-like compilers.
This binary currently does this:
- isolates `<src>`
- isolates `<out>`
- removes extra flags `-g`, `-o` and `-S`
- writes a file (`<input>`) containing all data after `---` if encountered in commandline
- detect if required output must be executable (`<exe>`)

You can use it by creating a symbolic link named `compiler.name`, where `name` is an executable in the `PATH`.

It then calls `./name` if file exists and is executable, else `name` with these arguments:
- `<exe>` (boolean, 1 if `<out>` must be executable)
- `<out>`
- `<src>`
- `<input>` (file containing data after `---`)
- `<args>` (user arguments before `---`)

### /ce/install_gcc

Arguments:
- version (complete, e.g. `8.1.0`)
- extension (optional, default: tar.xz)

Will install GCC in `/opt/gcc-${gcc_version}`.
