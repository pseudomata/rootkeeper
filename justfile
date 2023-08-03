# list out all tasks
default:
    just --list

# build project
build:
    zig build

# run tests
test:
    zig test src/*
