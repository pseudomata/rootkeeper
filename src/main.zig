const std = @import("std");
const process = std.process;

pub fn fatal(comptime format: []const u8, args: anytype) noreturn {
    std.log.err(format, args);
    process.exit(1);
}

const normal_usage =
    \\Usage: rootkeeper [command] [options]
    \\
    \\Commands:
    \\
    \\  init             Initialize a new repository with rootkeeper
    \\  version          Print version number and exit
    \\
    \\General Options:
    \\
    \\  -h, --help       Print command-specific usage
    \\
;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try std.process.argsAlloc(allocator);
    if (args.len <= 1) {
        std.log.info("{s}", .{normal_usage});
        fatal("expected command argument", .{});
    }
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
