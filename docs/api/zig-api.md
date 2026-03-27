# Zig API Reference

Auto-generated from Zig source files in [`src/`](https://github.com/Jesssullivan/zig-notify/tree/main/src).

These are the internal Zig modules. For C/Swift interop, see the [C FFI Reference](c-ffi.md).

### `notify.zig`

```zig
pub const Urgency = enum(u8) {
```

Send a desktop notification.
```zig
pub fn send(title: []const u8, body: ?[]const u8, urgency: Urgency) !void {
```

Initialize notification backend (Linux: notify_init, macOS: no-op).
```zig
pub fn init(app_name: []const u8) !void {
```

Clean up notification backend (Linux: notify_uninit, macOS: no-op).
```zig
pub fn deinit() void {
```


### `notify_linux.zig`

```zig
pub fn init(app_name: []const u8) !void {
```

```zig
pub fn deinit() void {
```

```zig
pub fn send(title: []const u8, body: ?[]const u8, urgency: notify.Urgency) !void {
```


### `notify_macos.zig`

```zig
pub fn send(title: []const u8, body: ?[]const u8, urgency: notify.Urgency) !void {
```

