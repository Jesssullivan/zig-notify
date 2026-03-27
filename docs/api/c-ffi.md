# C FFI Reference

Auto-generated from [`include/zig_notify.h`](https://github.com/Jesssullivan/zig-notify/blob/main/include/zig_notify.h).

Urgency level for notifications. 

```c
typedef enum {
    ZIG_NOTIFY_URGENCY_LOW = 0,
    ZIG_NOTIFY_URGENCY_NORMAL = 1,
    ZIG_NOTIFY_URGENCY_CRITICAL = 2,
} zig_notify_urgency_t;
```

Send a notification.

- **`title`**: Notification title.
- **`title_len`**: Length of title string.
- **`body`**: Notification body text (may be NULL).
- **`body_len`**: Length of body string (0 if NULL).
- **`urgency`**: Urgency level.
- **Returns**: 0 on success, -1 on failure.

macOS: UNUserNotificationCenter (requestAuthorization + add)
Linux: libnotify notify_notification_new + notify_notification_show

```c
int zig_notify_send(
    const char *title, size_t title_len,
    const char *body, size_t body_len,
    zig_notify_urgency_t urgency
);
```

Request notification permission (macOS only, no-op on Linux).

- **Returns**: 0 if granted, -1 if denied, -2 on error.

macOS: UNUserNotificationCenter.requestAuthorization
Linux: Always returns 0 (no permission model)

```c
int zig_notify_request_permission(void);
```

Initialize the notification system.
Must be called before zig_notify_send on Linux (calls notify_init).
No-op on macOS.

- **`app_name`**: Application name.
- **`app_name_len`**: Length of app name string.
- **Returns**: 0 on success, -1 on failure.

```c
int zig_notify_init(const char *app_name, size_t app_name_len);
```

Clean up notification resources.
Should be called on app exit on Linux (calls notify_uninit).
No-op on macOS.

```c
void zig_notify_deinit(void);
```

