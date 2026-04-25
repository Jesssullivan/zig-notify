/// macOS notification backend using osascript (AppleScript `display notification`).
///
/// Avoids the `UNUserNotificationCenter` Objective-C runtime dependency.
/// `UNUserNotificationCenter` requires an app bundle with an identifier,
/// so this library uses the simpler osascript approach which works from
/// any context (CLI tools, daemons, bundled apps).
///
/// No frameworks or system libraries are linked; `osascript` is a standard
/// macOS system binary available on all supported versions (13+).
const std = @import("std");
const notify = @import("notify.zig");

/// Send a notification via `osascript -e 'display notification ...'`.
///
/// Builds an AppleScript command string with the given title and optional
/// body, escaping special characters for AppleScript string literals.
/// Urgency is accepted for API compatibility but ignored -- macOS
/// `display notification` has no urgency concept.
///
/// The command buffer is 2048 bytes; extremely long title + body
/// combinations may return a write error.
///
/// Returns `error.SpawnFailed` if osascript cannot be launched, or
/// `error.WaitFailed` if the child process cannot be waited on.
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

/// Escape a string for use inside AppleScript double-quoted literals.
///
/// Backslash-escapes `"` and `\` characters. All other bytes are passed
/// through verbatim (AppleScript strings are UTF-8 compatible).
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
