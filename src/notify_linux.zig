const std = @import("std");
const notify = @import("notify.zig");

// Linux: libnotify (GLib-based notification API)
// Requires: libnotify-dev (Ubuntu) or libnotify-devel (Rocky/Fedora)

const c = @cImport({
    @cInclude("libnotify/notify.h");
});

var initialized = false;

pub fn init(app_name: []const u8) !void {
    var name_buf: [256]u8 = undefined;
    if (app_name.len >= name_buf.len) return error.NameTooLong;
    @memcpy(name_buf[0..app_name.len], app_name);
    name_buf[app_name.len] = 0;

    if (c.notify_init(&name_buf) == 0) return error.NotifyInitFailed;
    initialized = true;
}

pub fn deinit() void {
    if (initialized) {
        c.notify_uninit();
        initialized = false;
    }
}

pub fn send(title: []const u8, body: ?[]const u8, urgency: notify.Urgency) !void {
    if (!initialized) return error.NotInitialized;

    var title_buf: [512]u8 = undefined;
    if (title.len >= title_buf.len) return error.TitleTooLong;
    @memcpy(title_buf[0..title.len], title);
    title_buf[title.len] = 0;

    var body_ptr: ?[*:0]const u8 = null;
    var body_buf: [2048]u8 = undefined;
    if (body) |b| {
        if (b.len >= body_buf.len) return error.BodyTooLong;
        @memcpy(body_buf[0..b.len], b);
        body_buf[b.len] = 0;
        body_ptr = @ptrCast(&body_buf);
    }

    const n = c.notify_notification_new(&title_buf, body_ptr, null) orelse return error.NotificationCreateFailed;
    defer c.g_object_unref(@ptrCast(n));

    c.notify_notification_set_urgency(n, switch (urgency) {
        .low => c.NOTIFY_URGENCY_LOW,
        .normal => c.NOTIFY_URGENCY_NORMAL,
        .critical => c.NOTIFY_URGENCY_CRITICAL,
    });

    var err: ?*c.GError = null;
    if (c.notify_notification_show(n, &err) == 0) {
        if (err) |e| c.g_error_free(e);
        return error.NotificationShowFailed;
    }
}
