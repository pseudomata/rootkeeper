const std = @import("std");
const process = std.process;
const print = std.debug.print;
const mem = std.mem;

// Update when code changes. Primarily used for the 'version' command.
const version = "0.0.1";

// Usage and general help text to print when running the 'help' command.
// This text needs to be updated if a new command or option is added.
const usage =
    \\Usage: rootkeeper [command] [options]
    \\
    \\Commands:
    \\
    \\  help                 Prints this help text and exit
    \\  init                 Initialize a new repository with rootkeeper
    \\  update               Update configuration links and git ignores
    \\  version              Print version number and exit
    \\
    \\General Options:
    \\
    \\  -c, --config <path>  Path to configuration if not default (default: 'Rootfile')
    \\  -h, --help           Print command-specific usage
    \\  -v, --verbose        Log what rootkeeper is doing verbosely
    \\
;

// Enumerate every command the CLI has.
const Command = enum {
    help,
    init,
    update,
    version,
};

// Options for the tool, holds a path to the configuration file and other
// options that are needed while using the tool.
const Options = struct {
    config: []const u8 = "Rootfile",
    help: bool = false,
    verbose: bool = false,
};

// Log and error and exit with a non-zero exit code (currently just 1).
pub fn fatal(comptime format: []const u8, args: anytype) noreturn {
    std.log.err(format, args);
    process.exit(1);
}

// Print the help text and exit with a zero exit code.
pub fn printHelp() noreturn {
    print(usage, .{});
    process.exit(0);
}

// Print the binary version and exit with a zero exit code.
pub fn printVersion() noreturn {
    print(version, .{});
    process.exit(0);
}

// Go from a string to our command enum.
pub fn parseCommand(cmd: []const u8) !Command {
    if (mem.eql(u8, "help", cmd)) {
        return Command.help;
    } else if (mem.eql(u8, "init", cmd)) {
        return Command.init;
    } else if (mem.eql(u8, "update", cmd)) {
        return Command.update;
    } else if (mem.eql(u8, "version", cmd)) {
        return Command.version;
    } else {
        fatal("Unknown command: {s}", .{cmd});
    }
}

// Reads the rest of the CLI arguments and parses them out into an Options
// struct. Some positions are important (like the path to the config option)
//
//    ./rootkeeper init --config <path_for_config_file>
//
pub fn parseOptions(args: [][]u8) !Options {
    var opts = Options{};

    // TODO: I tried the following, which seems to be documented, but got an error:
    //
    //    for (args, 0..) |arg, index| { ... }
    //         ~~~~^~~~
    //         expected ')', found ','
    //
    // for (args, 0..) |arg, index| {
    for (args) |arg| {
        if (mem.eql(u8, "-h", arg) or mem.eql(u8, "--help", arg)) {
            opts.help = true;
        } else if (mem.eql(u8, "-v", arg) or mem.eql(u8, "--verbose", arg)) {
            opts.verbose = true;
        } else if (mem.eql(u8, "-c", arg) or mem.eql(u8, "--config", arg)) {
            // TODO: call fatal() if no file path after -c option passed in
            // if (index + 1 >= args.len) {
            //     fatal("Missing path to configuration file.", .{});
            // }
            const file_path = "get_this_from_arg+1";
            opts.config = file_path;
        } else {
            continue;
        }
    }
    return opts;
}

// Initialize a repository for rootkeeper.
//   1. Create new 'Rootfile' (unless alternative is provided with '-c' option)
//   2. Create a new directory where configurations are kept (default, override with '-d' option)
pub fn initializeRepo(opts: Options) !void {
    _ = opts;
    print("initialize repo", .{});
}

// When the 'Rootfile' (or alternative, passed with '-c' option) is modified we need to update
// the links and also update the .gitignore file
pub fn updateRepo(opts: Options) !void {
    _ = opts;
    print("update repo", .{});
}

// Wrapper function with just the switch statement for command enum
// to function for that specific command.
pub fn executeCommand(cmd: Command, opts: Options) !void {
    switch (cmd) {
        Command.help => {
            printHelp();
        },
        Command.init => {
            try initializeRepo(opts);
        },
        Command.update => {
            try updateRepo(opts);
        },
        Command.version => {
            printVersion();
        },
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const args = try process.argsAlloc(allocator);
    defer process.argsFree(allocator, args);
    if (args.len <= 1) {
        fatal("Expected a command. Try 'help'.", .{});
    }

    const cmd = try parseCommand(args[1]);
    const opts = try parseOptions(args[2..]);

    try executeCommand(cmd, opts);
}
