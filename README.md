# rootkeeper

Tool to manage dot files (e.g. for tool configuration etc.) in a separate configuration folder, keeping a repository root clean.

## Usage

```shell
Usage: rootkeeper [command] [options]

Commands:

  help                 Prints this help text and exit
  init                 Initialize a new repository with rootkeeper
  update               Update configuration links and git ignores
  version              Print version number and exit

General Options:

  -c, --config <path>  Path to configuration if not default (default: 'Rootfile')
  -h, --help           Print command-specific usage
  -v, --verbose        Log what rootkeeper is doing verbosely
```

## Dependencies

- `zig`
- `just`

```shell
$ just --list
Available recipes:
    build   # build project
    default # list out all tasks
    run     # build and then run the binary
    test    # run tests
```

## License

BSD 3-Clause. See [LICENSE](./LICENSE).
