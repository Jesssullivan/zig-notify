# AGENTS.md -- zig-notify

## Persona

You are working on zig-notify, a cross-platform desktop notification library written in Zig with a C FFI surface. It sends notifications via osascript on macOS and libnotify on Linux, exposing a unified 4-function C API. Part of the [Tinyland Zig Libraries](https://libs.tinyland.dev).

## Stack

- **Language:** Zig 0.14.1+
- **Output:** Static C library (`libzig-notify.a`) + Zig module
- **Dependencies:** None on macOS (osascript is a system binary); libnotify + glib-2.0 on Linux
- **Header:** `include/zig_notify.h` (4 C FFI functions)
- **Tests:** Unit tests in `src/notify.zig`
- **Docs:** MkDocs Material + Zig autodoc (`zig build docs`)

## Structure

```
src/ffi.zig              C FFI exports (4 functions)
src/notify.zig           Platform dispatch (comptime macOS/Linux)
src/notify_macos.zig     macOS backend (osascript `display notification`)
src/notify_linux.zig     Linux backend (libnotify GLib API)
include/zig_notify.h     C header with all function signatures and types
examples/                C usage example
```

## Commands

```bash
zig build                              # static library -> zig-out/lib/
zig build -Doptimize=ReleaseFast       # optimized build
zig build test                         # unit tests
zig build docs                         # generate API documentation
```

## Style

- Format with `zig fmt`
- All `pub` and `export` functions require `///` doc comments
- C FFI exports live exclusively in `src/ffi.zig`
- Platform backends in `src/notify_<platform>.zig`, one file per platform
- Error convention: return `0` on success, `-1` on failure from C FFI

## Boundaries

- **Do not** add GUI toolkit dependencies (GTK, Qt, Cocoa frameworks)
- **Do not** bypass osascript on macOS (UNUserNotificationCenter requires an app bundle)
- **Do not** add allocator-dependent APIs to the FFI surface (all buffers use fixed-size stacks)
- **Do not** make libnotify calls from multiple threads (libnotify is not thread-safe)
- **Do** keep the init/send/deinit lifecycle simple and symmetric across platforms
- **Do** ensure new platform backends implement `init`, `deinit`, and `send`

## C FFI Exports (zig_notify.h)

| Function | Return | Description |
|----------|--------|-------------|
| `zig_notify_init` | `int` (0/-1) | Initialize notification backend (Linux: `notify_init`) |
| `zig_notify_send` | `int` (0/-1) | Send notification with title, body, urgency |
| `zig_notify_request_permission` | `int` (0/-1/-2) | Request permission (currently no-op on all platforms) |
| `zig_notify_deinit` | `void` | Clean up notification resources |

## Types

- `zig_notify_urgency_t` -- Enum: `ZIG_NOTIFY_URGENCY_LOW` (0), `ZIG_NOTIFY_URGENCY_NORMAL` (1), `ZIG_NOTIFY_URGENCY_CRITICAL` (2).

## Thread Safety

On macOS, `zig_notify_send` spawns an `osascript` child process per call -- thread-safe but not suitable for high-frequency use. On Linux, libnotify functions are not thread-safe; call from a single thread or synchronize externally. `init` and `deinit` must be called from the same thread.

## Platform Requirements

**macOS:**
- No frameworks needed (uses `osascript` binary, available on all macOS 13+ systems)
- Urgency levels are accepted but ignored (macOS notifications have no urgency concept)

**Linux:**
- `apt install libnotify-dev` (Ubuntu/Debian) or `dnf install libnotify-devel` (Fedora/Rocky)
- glib-2.0, gobject-2.0 (dependencies of libnotify)
- A running notification daemon (dunst, mako, GNOME Shell, etc.)
