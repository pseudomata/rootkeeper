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
    \\  help             Prints this help text and exit
    \\  init             Initialize a new repository with rootkeeper
    \\  version          Print version number and exit
    \\
    \\General Options:
    \\
    \\  -h, --help       Print command-specific usage
    \\
;

pub fn fatal(comptime format: []const u8, args: anytype) noreturn {
    std.log.err(format, args);
    process.exit(1);
}

const Command = enum {
    help,
    init,
    version,
};

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

// pub fn parse_command_args() {}

// pub fn parse_flags() {}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);
    if (args.len <= 1) {
        fatal("Expected a command. Try 'help'.", .{});
    }

    const cmd = parseCommand(args[1]);
    // const cmd_args = args[2..];

    switch (cmd) {
        Command.help => {
            printHelp();
        },
        Command.init => {
            print("We are in: {}", .{cmd});
        },
        Command.version => {
            printVersion();
        },
    }
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
