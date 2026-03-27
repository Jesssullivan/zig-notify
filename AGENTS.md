# zig-notify -- Agent Interface

## Capabilities

- Send desktop notifications with title, body, and urgency level
- Request notification permission (macOS)
- Initialize/cleanup notification backend lifecycle (Linux)
- Cross-platform: macOS osascript and Linux libnotify

## C FFI Exports

```c
typedef enum {
    ZIG_NOTIFY_URGENCY_LOW = 0,
    ZIG_NOTIFY_URGENCY_NORMAL = 1,
    ZIG_NOTIFY_URGENCY_CRITICAL = 2,
} zig_notify_urgency_t;

int zig_notify_init(const char *app_name, size_t app_name_len);

int zig_notify_send(
    const char *title, size_t title_len,
    const char *body, size_t body_len,
    zig_notify_urgency_t urgency
);

int zig_notify_request_permission(void);

void zig_notify_deinit(void);
```

## Error Codes

- **init**: `0` = success, `-1` = failure
- **send**: `0` = success, `-1` = failure
- **request_permission**: `0` = granted, `-1` = denied, `-2` = error
- **deinit**: No return value (always succeeds)

## Thread Safety

On macOS, `zig_notify_send` spawns an `osascript` child process per call -- thread-safe but not suitable for high-frequency use. On Linux, libnotify functions are not thread-safe; call from a single thread or synchronize externally. `init` and `deinit` must be called from the same thread.

## Platform Requirements

**macOS:**
- No frameworks needed (uses `osascript` binary, available on all macOS systems)
- Urgency levels are ignored (macOS notifications have no urgency concept in display)

**Linux:**
- `apt install libnotify-dev` (Ubuntu/Debian) or `dnf install libnotify-devel` (Fedora/Rocky)
- glib-2.0, gobject-2.0 (dependencies of libnotify)
- A running notification daemon (dunst, mako, GNOME Shell, etc.)

## Example: Complete Usage

```c
#include "zig_notify.h"
#include <string.h>

int main(void) {
    // Initialize (required on Linux, no-op on macOS)
    zig_notify_init("MyApp", 5);

    // Send a notification
    const char *title = "Build Complete";
    const char *body = "Release build finished successfully";
    zig_notify_send(
        title, strlen(title),
        body, strlen(body),
        ZIG_NOTIFY_URGENCY_NORMAL
    );

    // Send title-only notification
    const char *alert = "Warning";
    zig_notify_send(alert, strlen(alert), NULL, 0, ZIG_NOTIFY_URGENCY_CRITICAL);

    // Cleanup (required on Linux, no-op on macOS)
    zig_notify_deinit();

    return 0;
}
```
