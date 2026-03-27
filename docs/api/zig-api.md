# Zig API Reference: zig-notify

## `notify.zig`
*Platform notification abstraction*

### Types

#### `Urgency` (enum)

### Functions

#### `send`
Send a desktop notification.

```zig
pub fn send(title: []const u8, body: ?[]const u8, urgency: Urgency) !void
```

#### `init`
Initialize notification backend (Linux: notify_init, macOS: no-op).

```zig
pub fn init(app_name: []const u8) !void
```

#### `deinit`
Clean up notification backend (Linux: notify_uninit, macOS: no-op).

```zig
pub fn deinit() void
```

## `notify_linux.zig`
*Linux libnotify backend*

### Functions

#### `init`

```zig
pub fn init(app_name: []const u8) !void
```

#### `deinit`

```zig
pub fn deinit() void
```

#### `send`

```zig
pub fn send(title: []const u8, body: ?[]const u8, urgency: notify.Urgency) !void
```

## `notify_macos.zig`
*macOS UNUserNotificationCenter backend*

### Functions

#### `send`

```zig
pub fn send(title: []const u8, body: ?[]const u8, urgency: notify.Urgency) !void
```

