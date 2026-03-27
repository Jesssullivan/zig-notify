# C FFI API Reference: zig-notify

## `zig_notify.h`

| Function | Description |
|----------|-------------|
| `zig_notify_send` | Send a notification. macOS: UNUserNotificationCenter (requestAuthorization + add) Linux: libnotify notify_notification_new + notify_notification_show |
| `zig_notify_request_permission` | Request notification permission (macOS only, no-op on Linux). macOS: UNUserNotificationCenter.requestAuthorization Linux: Always returns 0 (no permission model) |
| `zig_notify_init` | Initialize the notification system. Must be called before zig_notify_send on Linux (calls notify_init). No-op on macOS. |
| `zig_notify_deinit` | Clean up notification resources. Should be called on app exit on Linux (calls notify_uninit). No-op on macOS. |

---

### `zig_notify_send`

Send a notification. macOS: UNUserNotificationCenter (requestAuthorization + add) Linux: libnotify notify_notification_new + notify_notification_show

```c
int zig_notify_send( const char *title, size_t title_len, const char *body, size_t body_len, zig_notify_urgency_t urgency );
```

**Parameters:**

- `title`: Notification title.
- `title_len`: Length of title string.
- `body`: Notification body text (may be NULL).
- `body_len`: Length of body string (0 if NULL).
- `urgency`: Urgency level.

**Returns:** 0 on success, -1 on failure.

### `zig_notify_request_permission`

Request notification permission (macOS only, no-op on Linux). macOS: UNUserNotificationCenter.requestAuthorization Linux: Always returns 0 (no permission model)

```c
int zig_notify_request_permission(void);
```

**Returns:** 0 if granted, -1 if denied, -2 on error.

### `zig_notify_init`

Initialize the notification system. Must be called before zig_notify_send on Linux (calls notify_init). No-op on macOS.

```c
int zig_notify_init(const char *app_name, size_t app_name_len);
```

**Parameters:**

- `app_name`: Application name.
- `app_name_len`: Length of app name string.

**Returns:** 0 on success, -1 on failure.

### `zig_notify_deinit`

Clean up notification resources. Should be called on app exit on Linux (calls notify_uninit). No-op on macOS.

```c
void zig_notify_deinit(void);
```

