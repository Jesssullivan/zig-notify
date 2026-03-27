const notify = @import("notify.zig");

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

export fn zig_notify_request_permission() c_int {
    // macOS: would need ObjC bridge for UNUserNotificationCenter
    // Linux: no permission model
    return 0;
}

export fn zig_notify_init(app_name: [*]const u8, app_name_len: usize) c_int {
    notify.init(app_name[0..app_name_len]) catch return -1;
    return 0;
}

export fn zig_notify_deinit() void {
    notify.deinit();
}
