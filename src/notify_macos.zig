const std = @import("std");
const notify = @import("notify.zig");

// macOS: Use osascript for notifications (avoids UNUserNotificationCenter
// Objective-C runtime dependency). For production, this should use the
// Objective-C runtime directly via @cImport or a thin ObjC bridge.
//
// UNUserNotificationCenter requires an app bundle with an identifier,
// so for a library we use the simpler osascript approach which works
// from any context.

pub fn send(title: []const u8, body: ?[]const u8, urgency: notify.Urgency) !void {
    _ = urgency; // macOS doesn't have urgency levels in display

    // Build osascript command
    var cmd_buf: [2048]u8 = undefined;
    var stream = std.io.fixedBufferStream(&cmd_buf);
    const writer = stream.writer();

    try writer.writeAll("display notification \"");
    if (body) |b| {
        try escapeAppleScript(writer, b);
    }
    try writer.writeAll("\" with title \"");
    try escapeAppleScript(writer, title);
    try writer.writeByte('"');

    const cmd_len = stream.pos;
    cmd_buf[cmd_len] = 0;

    // Execute via osascript
    const argv = [_][]const u8{ "osascript", "-e", cmd_buf[0..cmd_len] };
    var child = std.process.Child.init(&argv, std.heap.page_allocator);
    child.spawn() catch return error.SpawnFailed;
    _ = child.wait() catch return error.WaitFailed;
}

fn escapeAppleScript(writer: anytype, s: []const u8) !void {
    for (s) |c| {
        if (c == '"') {
            try writer.writeAll("\\\"");
        } else if (c == '\\') {
            try writer.writeAll("\\\\");
        } else {
            try writer.writeByte(c);
        }
    }
}
