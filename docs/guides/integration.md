# Integration Guide

## As a Zig Dependency

Add to your `build.zig.zon`:

```zig
.dependencies = .{
    .zig_notify = .{
        .url = "https://github.com/Jesssullivan/zig-notify/archive/refs/heads/main.tar.gz",
    },
},
```

Then in `build.zig`:

```zig
const notify_dep = b.dependency("zig_notify", .{
    .target = target,
    .optimize = optimize,
});
exe.linkLibrary(notify_dep.artifact("zig_notify"));
```

## As a C Static Library

Build and link against `libzig_notify.a`:

```c
#include "zig_notify.h"

int main() {
    // Initialize (required on Linux, no-op on macOS)
    zig_notify_init("myapp", 5);

    // Request permission (macOS only, no-op on Linux)
    zig_notify_request_permission();

    // Send notification
    const char *title = "Hello";
    const char *body = "World";
    zig_notify_send(title, 5, body, 5, ZIG_NOTIFY_URGENCY_NORMAL);

    // Clean up (required on Linux, no-op on macOS)
    zig_notify_deinit();
    return 0;
}
```

## Swift Integration

```swift
import Foundation

// Send a notification
let title = "Download Complete"
let body = "Your file has been saved"
zig_notify_send(
    title, title.utf8.count,
    body, body.utf8.count,
    ZIG_NOTIFY_URGENCY_NORMAL.rawValue
)
```

## Urgency Levels

| Level | Value | Description |
|-------|-------|-------------|
| `ZIG_NOTIFY_URGENCY_LOW` | 0 | Low priority, may be silent |
| `ZIG_NOTIFY_URGENCY_NORMAL` | 1 | Standard notification |
| `ZIG_NOTIFY_URGENCY_CRITICAL` | 2 | Critical, may bypass Do Not Disturb |
