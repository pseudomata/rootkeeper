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

- `zig` version `0.11.0` (https://ziglang.org/learn/getting-started/)
- `just` (https://just.systems/man/en/)

```shell
$ just --list
Available recipes:
    build   # build project
    clean   # delete the build output and cache
    default # list out all tasks
    fmt     # format the codebase using zig fmt
    run     # build and then run the binary
    test    # run tests
```

## License

Mozilla Public License, v. 2.0. See [LICENSE](./LICENSE).

```
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at http://mozilla.org/MPL/2.0/.
```
