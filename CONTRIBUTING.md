# Contributing to zig-notify

## Installation

### Zig Package Manager (recommended)

```bash
zig fetch --save git+https://github.com/Jesssullivan/zig-notify.git
```

Then in your `build.zig`:

```zig
const dep = b.dependency("zig_notify", .{ .target = target, .optimize = optimize });
exe.root_module.addImport("zig-notify", dep.module("zig-notify"));
```

### Git Submodule (C FFI consumers)

```bash
git submodule add https://github.com/Jesssullivan/zig-notify.git vendor/notify
cd vendor/notify && zig build -Doptimize=ReleaseFast
```

Link (macOS): `-lzig-notify` (no frameworks; uses osascript binary).
Link (Linux): `-lzig-notify -lnotify -lglib-2.0 -lgobject-2.0`.
Include: `#include "zig_notify.h"`.

## Development

### Prerequisites

- Zig 0.15.2+
- **macOS**: No additional dependencies (osascript is a system binary)
- **Linux**: `sudo apt install libnotify-dev libglib2.0-dev libgdk-pixbuf-2.0-dev` (Debian/Ubuntu) or `sudo dnf install libnotify-devel glib2-devel gdk-pixbuf2-devel` (Fedora/Rocky)

### Build & Test

```bash
zig build                        # static library
zig build -Doptimize=ReleaseFast # optimized build
zig build test                   # unit tests
zig build docs                   # generate API documentation
zig build example                # build C example
```

## Where to Start

Start with issues labeled [`good first issue`](https://github.com/Jesssullivan/zig-notify/labels/good%20first%20issue) or [`help wanted`](https://github.com/Jesssullivan/zig-notify/labels/help%20wanted).

Small, useful first contributions include:

- SwiftPM/modulemap smoke tests
- Objective-C bridging samples
- C header nullability annotations
- Swift wrapper examples
- `UNUserNotificationCenter` migration documentation

### Code Style

- `zig fmt` for formatting
- All `pub` and `export` functions need `///` doc comments
- C FFI exports go in `src/ffi.zig`
- Zig package exports go through `src/root.zig`
- Platform backends in `src/notify_<platform>.zig`

### Adding a new platform backend

1. Create `src/notify_<platform>.zig` with `init`, `deinit`, and `send` functions
2. Add a comptime branch in `src/notify.zig` for the new `os.tag`
3. Update system include paths in `build.zig` if the backend needs C headers
4. Add the C header declarations to `include/zig_notify.h` if new types are introduced
5. Document platform requirements in `AGENTS.md` and `README.md`

## Filing Issues

Open an issue at [github.com/Jesssullivan/zig-notify/issues](https://github.com/Jesssullivan/zig-notify/issues).

## License

Dual-licensed under [Zlib](https://opensource.org/licenses/Zlib) and [MIT](https://opensource.org/licenses/MIT).
