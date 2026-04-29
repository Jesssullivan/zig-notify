# Source Tree: zig-notify

```
zig-notify/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.yml
│   │   ├── config.yml
│   │   ├── documentation.yml
│   │   └── feature_request.yml
│   ├── workflows/
│   │   ├── ci.yml
│   │   ├── docs.yml
│   │   └── release.yml
│   └── PULL_REQUEST_TEMPLATE.md
├── docs/
│   ├── api/
│   │   ├── c-ffi.md  (C FFI API Reference: zig-notify)
│   │   └── zig-api.md  (Zig API Reference: zig-notify)
│   ├── guides/
│   │   ├── apple-interop.md  (Apple Interop)
│   │   ├── building.md  (Building)
│   │   └── integration.md  (Integration Guide)
│   ├── agents.md  (AGENTS.md)
│   ├── index.md  (zig-notify)
│   ├── llms.txt
│   └── source-tree.md  (Source Tree: zig-notify)
├── examples/
│   └── send_notification.c
├── include/
│   └── zig_notify.h  (C header -- 4 functions)
├── scripts/
│   ├── gen_api_docs.py
│   └── gen_docs.py
├── src/
│   ├── ffi.zig  (C FFI surface for zig-notify.)
│   ├── notify.zig  (Platform-dispatching notification module.)
│   ├── notify_linux.zig  (Linux notification backend using libnotify (GLib-based no...)
│   ├── notify_macos.zig  (macOS notification backend using osascript (AppleScript `...)
│   └── root.zig  (Public Zig package API for zig-notify.)
├── .coderabbit.yaml
├── .envrc
├── .gitignore
├── AGENTS.md  (AGENTS.md -- zig-notify)
├── CONTRIBUTING.md  (Contributing to zig-notify)
├── LICENSE  (License)
├── README.md  (zig-notify)
├── SECURITY.md  (Security Policy)
├── build.zig
├── build.zig.zon
├── flake.lock  (Nix flake lockfile)
├── flake.nix  (Nix flake)
├── llms-full.txt
├── llms.txt
└── mkdocs.yml  (MkDocs configuration)
```
