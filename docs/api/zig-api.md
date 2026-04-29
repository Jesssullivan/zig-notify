# Zig API Reference: zig-notify

## `notify.zig`
*Platform-dispatching notification module.*

### Types

#### `Urgency` (enum)
Notification urgency level.  Maps to libnotify urgency on Linux (`NOTIFY_URGENCY_LOW`, `_NORMAL`, `_CRITICAL`). On macOS, the value is accepted but ignored because `display notification` has no urgency concept.

### Functions

#### `send`
Send a desktop notification with the given title, optional body, and urgency.  On macOS: executes `osascript -e 'display notification ...'`. On Linux: calls `notify_notification_new` + `notify_notification_show`. Returns `error.UnsupportedPlatform` on other operating systems.

```zig
pub fn send(title: []const u8, body: ?[]const u8, urgency: Urgency) !void
```

#### `init`
Initialize the notification backend.  On Linux, calls `notify_init` to register the application name with libnotify. Must be called before `send`. On macOS this is a no-op because osascript requires no initialization.

```zig
pub fn init(app_name: []const u8) !void
```

#### `deinit`
Clean up the notification backend.  On Linux, calls `notify_uninit` to release libnotify resources. Should be called once on application exit. On macOS this is a no-op.

```zig
pub fn deinit() void
```

## `notify_linux.zig`
*Linux notification backend using libnotify (GLib-based no...*

### Functions

#### `init`
Initialize libnotify with the given application name.  Calls `notify_init(app_name)` to register the application with the notification daemon. Must be called exactly once before `send`. `app_name` must be at most 255 bytes.  Returns `error.NameTooLong` if `app_name` exceeds the internal buffer, or `error.NotifyInitFailed` if `notify_init` returns failure.

```zig
pub fn init(app_name: []const u8) !void
```

#### `deinit`
Release libnotify resources.  Calls `notify_uninit()` if the backend was previously initialized. Safe to call multiple times; subsequent calls are no-ops.

```zig
pub fn deinit() void
```

#### `send`
Send a notification via libnotify.  Creates a `NotifyNotification` with the given title, optional body, and urgency level, then calls `notify_notification_show`.  Title is limited to 511 bytes, body to 2047 bytes. Exceeding these returns `error.TitleTooLong` or `error.BodyTooLong` respectively. Returns `error.NotInitialized` if `init` was not called first.

```zig
pub fn send(title: []const u8, body: ?[]const u8, urgency: notify.Urgency) !void
```

## `notify_macos.zig`
*macOS notification backend using osascript (AppleScript `...*

### Functions

#### `send`
Send a notification via `osascript -e 'display notification ...'`.  Builds an AppleScript command string with the given title and optional body, escaping special characters for AppleScript string literals. Urgency is accepted for API compatibility but ignored -- macOS `display notification` has no urgency concept.  The command buffer is 2048 bytes; extremely long title + body combinations may return a write error.  Returns `error.SpawnFailed` if osascript cannot be launched, or `error.WaitFailed` if the child process cannot be waited on.

```zig
pub fn send(title: []const u8, body: ?[]const u8, urgency: notify.Urgency) !void
```

## `root.zig`
*Public Zig package API for zig-notify.*

### Constants

- `notify`
- `Urgency`
- `send`
- `init`
- `deinit`

