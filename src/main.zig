const std = @import("std");
const process = std.process;
const print = std.debug.print;
const mem = std.mem;

const version = "v0.0.1";

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

const Command = enum {
    help,
    init,
    update,
    version,
};

const Options = struct {
    config: []const u8 = "Rootfile",
    help: bool = false,
    verbose: bool = false,
};

pub fn fatal(comptime format: []const u8, args: anytype) noreturn {
    std.log.err(format, args);
    process.exit(1);
}

pub fn printHelp() noreturn {
    print(usage, .{});
    process.exit(0);
}

pub fn printVersion() noreturn {
    print(version, .{});
    process.exit(0);
}

pub fn parseCommand(cmd: []const u8) Command {
    if (mem.eql(u8, "help", cmd)) {
        return Command.help;
    } else if (mem.eql(u8, "init", cmd)) {
        return Command.init;
    } else if (mem.eql(u8, "version", cmd)) {
        return Command.version;
    } else {
        fatal("Unknown command: {s}", .{cmd});
    }
}

pub fn parseOptions(args: [][]u8) Options {
    var opts = Options{};

    for (args) |arg| {
        if (mem.eql(u8, "-h", arg) or mem.eql(u8, "--help", arg)) {
            opts.help = true;
        } else if (mem.eql(u8, "-v", arg) or mem.eql(u8, "--verbose", arg)) {
            opts.verbose = true;
        } else if (mem.eql(u8, "-c", arg) or mem.eql(u8, "--config", arg)) {
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

pub fn initializeRepo(opts: Options) void {
    _ = opts;
    print("initialize repo", .{});
}

pub fn updateRepo(opts: Options) void {
    _ = opts;
    print("update repo", .{});
}

pub fn executeCommand(cmd: Command, opts: Options) !void {
    switch (cmd) {
        Command.help => {
            printHelp();
        },
        Command.init => {
            initializeRepo(opts);
        },
        Command.update => {
            updateRepo(opts);
        },
        Command.version => {
            printVersion();
        },
    }
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    if (args.len <= 1) {
        fatal("Expected a command. Try 'help'.", .{});
    }

    const cmd = parseCommand(args[1]);
    const opts = parseOptions(args[2..]);

    try executeCommand(cmd, opts);
}
