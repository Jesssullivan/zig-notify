const std = @import("std");
const builtin = @import("builtin");

pub const Urgency = enum(u8) {
    low = 0,
    normal = 1,
    critical = 2,
};

/// Send a desktop notification.
pub fn send(title: []const u8, body: ?[]const u8, urgency: Urgency) !void {
    if (builtin.os.tag == .macos) {
        return @import("notify_macos.zig").send(title, body, urgency);
    } else if (builtin.os.tag == .linux) {
        return @import("notify_linux.zig").send(title, body, urgency);
    } else {
        return error.UnsupportedPlatform;
    }
}

/// Initialize notification backend (Linux: notify_init, macOS: no-op).
pub fn init(app_name: []const u8) !void {
    if (builtin.os.tag == .linux) {
        return @import("notify_linux.zig").init(app_name);
    }
}

/// Clean up notification backend (Linux: notify_uninit, macOS: no-op).
pub fn deinit() void {
    if (builtin.os.tag == .linux) {
        @import("notify_linux.zig").deinit();
    }
}
