# list out all tasks
default:
    just --list

# build project
build:
    zig build

# delete the build output and cache
clean:
    rm -rf zig-cache/
    rm -rf zig-out/

# format the codebase using zig fmt
fmt:
    zig fmt src/

# run tests
test:
    zig test src/*

# build and then run the binary
run: build
    ./zig-out/bin/rootkeeper
