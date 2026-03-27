# Source Tree: zig-notify

```
zig-notify/
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── docs.yml
├── docs/
│   ├── api/
│   │   ├── c-ffi.md  (C FFI API Reference: zig-notify)
│   │   └── zig-api.md  (Zig API Reference: zig-notify)
│   ├── guides/
│   │   ├── building.md  (Building)
│   │   └── integration.md  (Integration Guide)
│   ├── agents.md  (AGENTS.md)
│   ├── index.md  (zig-notify)
│   ├── llms.txt
│   └── source-tree.md  (Source Tree: zig-notify)
├── include/
│   └── zig_notify.h  (C header -- 4 functions)
├── scripts/
│   ├── gen_api_docs.py
│   └── gen_docs.py
├── src/
│   ├── ffi.zig  (C FFI exports)
│   ├── notify.zig  (Platform notification abstraction)
│   ├── notify_linux.zig  (Linux libnotify backend)
│   └── notify_macos.zig  (macOS UNUserNotificationCenter backend)
├── tests/
├── .coderabbit.yaml
├── .envrc
├── .gitignore
├── AGENTS.md  (AGENTS.md -- zig-notify)
├── LICENSE  (License)
├── LLMS.txt
├── build.zig
├── flake.nix  (Nix flake)
└── mkdocs.yml  (MkDocs configuration)
```
