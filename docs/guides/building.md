# Building

## Requirements

- Zig 0.15.2+
- macOS 13+ or Linux with libnotify

## Static Library

```bash
zig build -Doptimize=ReleaseFast
```

Produces `zig-out/lib/libzig-notify.a` with the C header at `include/zig_notify.h`.

## With Nix

```bash
nix develop        # dev shell with Zig 0.15.2
```

## Running Tests

```bash
zig build test
```

## Platform Dependencies

**macOS**: Uses the system `osascript` binary. No Apple notification framework is linked by this library.

**Linux**: Requires `libnotify-dev`:

```bash
# Debian/Ubuntu
sudo apt install libnotify-dev

# Fedora
sudo dnf install libnotify-devel
```

Linux runtime delivery also requires a desktop notification daemon such as GNOME Shell, dunst, mako, or another implementation that receives libnotify/D-Bus notifications.
