# Apple Interop

zig-notify is a portable notification FFI, not a SwiftUI or Cocoa application framework. It is useful when an application only needs a small local-notification capability that can move between Apple platforms and Linux without keeping separate notification call sites.

## Apple Analogs

The closest Apple surfaces are:

- `UNUserNotificationCenter.add` for local notification delivery
- `UNMutableNotificationContent` for title/body content
- legacy AppleScript `display notification`
- Swift or Objective-C bridging headers for C ABI calls

The current macOS backend uses AppleScript through `osascript`. It does not link `UserNotifications.framework`, require an app bundle identifier, or expose `UNUserNotificationCenter` delegate hooks.

## Available Now

- C ABI callable from Swift, Objective-C, C, C++, and other FFI hosts
- `zig_notify_send` for title/body desktop notifications
- Linux libnotify urgency mapping
- macOS title/body delivery through `osascript display notification`
- Direct Zig package API through `src/root.zig`

## Not Yet Available

- SwiftPM package, module map, or XCFramework packaging
- Objective-C sample app and nullability annotations
- Dedicated Swift wrapper types around the C ABI
- `UNUserNotificationCenter` migration examples
- Categories, actions, sounds, attachments, scheduling, delivered-notification queries, APNs, or delegate callbacks
- A second macOS backend that calls `UNUserNotificationCenter` directly

## Contributor Starting Points

Good first issues should stay small and should make one missing interop path easier to verify. Useful starting points include a SwiftPM/modulemap smoke test, an Objective-C bridge sample, C header nullability annotations, and a migration table from `UNUserNotificationCenter` concepts to the current zig-notify surface.
