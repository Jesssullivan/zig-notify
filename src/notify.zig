/// Platform-dispatching notification module.
///
/// Routes `send`, `init`, and `deinit` to the correct platform backend
/// at comptime: `notify_macos.zig` on macOS, `notify_linux.zig` on Linux.
/// Returns `error.UnsupportedPlatform` on other targets.
const std = @import("std");
const builtin = @import("builtin");

/// Notification urgency level.
///
/// Maps to libnotify urgency on Linux (`NOTIFY_URGENCY_LOW`, `_NORMAL`,
/// `_CRITICAL`). On macOS, the value is accepted but ignored because
/// `display notification` has no urgency concept.
pub const Urgency = enum(u8) {
    low = 0,
    normal = 1,
    critical = 2,
};

/// Send a desktop notification with the given title, optional body, and urgency.
///
/// On macOS: executes `osascript -e 'display notification ...'`.
/// On Linux: calls `notify_notification_new` + `notify_notification_show`.
/// Returns `error.UnsupportedPlatform` on other operating systems.
pub fn send(title: []const u8, body: ?[]const u8, urgency: Urgency) !void {
    if (builtin.os.tag == .macos) {
        return @import("notify_macos.zig").send(title, body, urgency);
    } else if (builtin.os.tag == .linux) {
        return @import("notify_linux.zig").send(title, body, urgency);
    } else {
        return error.UnsupportedPlatform;
    }
}

/// Initialize the notification backend.
///
/// On Linux, calls `notify_init` to register the application name with
/// libnotify. Must be called before `send`. On macOS this is a no-op
/// because osascript requires no initialization.
pub fn init(app_name: []const u8) !void {
    if (builtin.os.tag == .linux) {
        return @import("notify_linux.zig").init(app_name);
    }
}

/// Clean up the notification backend.
///
/// On Linux, calls `notify_uninit` to release libnotify resources.
/// Should be called once on application exit. On macOS this is a no-op.
pub fn deinit() void {
    if (builtin.os.tag == .linux) {
        @import("notify_linux.zig").deinit();
    }
}
