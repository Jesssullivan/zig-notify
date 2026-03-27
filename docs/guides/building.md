# Building

## Requirements

- Zig 0.15.2+
- macOS 13+ or Linux with libnotify

## Static Library

```bash
zig build -Doptimize=ReleaseFast
```

Produces `zig-out/lib/libzig_notify.a` with the C header at `include/zig_notify.h`.

## With Nix

```bash
nix develop        # dev shell
nix build          # build package
```

## Running Tests

```bash
zig build test
```

## Platform Dependencies

**macOS**: Uses `UNUserNotificationCenter` via ObjC bridge. Links against `UserNotifications.framework` at final link time.

**Linux**: Requires `libnotify-dev`:

```bash
# Debian/Ubuntu
sudo apt install libnotify-dev

# Fedora
sudo dnf install libnotify-devel
```
