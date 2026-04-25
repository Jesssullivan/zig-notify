/// C FFI surface for zig-notify.
///
/// Provides four exported functions for cross-platform desktop notifications:
/// `zig_notify_init`, `zig_notify_send`, `zig_notify_request_permission`,
/// and `zig_notify_deinit`. See `include/zig_notify.h` for the C header.
const notify = @import("notify.zig");

/// Send a desktop notification with title, optional body, and urgency level.
///
/// `title` and `title_len` specify the notification title (required, non-null).
/// `body` may be null for title-only notifications; if non-null, `body_len`
/// gives its length.
/// `urgency` maps to `zig_notify_urgency_t`: 0 = low, 1 = normal, 2 = critical.
///
/// On macOS, the notification is sent via `osascript "display notification"`;
/// urgency is accepted but ignored (macOS has no urgency concept).
/// On Linux, uses libnotify `notify_notification_new` +
/// `notify_notification_show` with the requested urgency.
///
/// Returns 0 on success, -1 on failure.
export fn zig_notify_send(
    title: [*]const u8,
    title_len: usize,
    body: ?[*]const u8,
    body_len: usize,
    urgency: u8,
) c_int {
    const body_slice: ?[]const u8 = if (body != null and body_len > 0) body.?[0..body_len] else null;
    notify.send(
        title[0..title_len],
        body_slice,
        @enumFromInt(urgency),
    ) catch return -1;
    return 0;
}

/// Request notification permission from the operating system.
///
/// On macOS this would use `UNUserNotificationCenter.requestAuthorization`;
/// the current implementation returns 0 immediately because the osascript
/// backend does not require explicit permission.
/// On Linux there is no permission model, so this always returns 0.
///
/// Returns 0 if granted, -1 if denied, -2 on error.
export fn zig_notify_request_permission() c_int {
    // macOS: would need ObjC bridge for UNUserNotificationCenter
    // Linux: no permission model
    return 0;
}

/// Initialize the notification backend.
///
/// Must be called before `zig_notify_send` on Linux, where it calls
/// `notify_init(app_name)` to register the application with libnotify.
/// No-op on macOS (osascript needs no initialization).
///
/// `app_name` and `app_name_len` specify the application name shown in
/// notifications on Linux. Maximum length is 255 bytes.
///
/// Returns 0 on success, -1 on failure.
export fn zig_notify_init(app_name: [*]const u8, app_name_len: usize) c_int {
    notify.init(app_name[0..app_name_len]) catch return -1;
    return 0;
}

/// Clean up notification backend resources.
///
/// On Linux, calls `notify_uninit()` to release libnotify state.
/// Should be called once on application exit.
/// No-op on macOS.
export fn zig_notify_deinit() void {
    notify.deinit();
}
