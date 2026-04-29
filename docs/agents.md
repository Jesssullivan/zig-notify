# AGENTS.md

Instructions for AI agents working with this codebase.

## Project

zig-notify provides portable desktop notifications in Zig. It exposes macOS osascript notifications and Linux libnotify behind a unified C FFI.

## Build

```bash
zig build -Doptimize=ReleaseFast    # static library
zig build test                       # tests
```

## Structure

- `include/zig_notify.h` -- Public C API header
- `src/root.zig` -- Zig package API root
- `src/ffi.zig` -- C FFI export layer
- `src/notify.zig` -- Platform dispatch (routes to macos/linux impl)
- `src/notify_macos.zig` -- macOS backend (osascript)
- `src/notify_linux.zig` -- Linux backend (libnotify)

## Conventions

- C exports use `snake_case` with `zig_notify_` prefix
- Zig internals use `camelCase`
- Platform-specific code in `_macos.zig` / `_linux.zig` files
- Return values: 0 = success, -1 = failure
- Linux requires init/deinit lifecycle; macOS does not
- The current macOS backend is not `UNUserNotificationCenter` and does not expose categories, actions, scheduling, attachments, or delegate callbacks
