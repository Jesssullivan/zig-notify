# Security Policy

zig-notify is a small desktop notification FFI library. Treat suspected memory-safety, command construction, build-chain, package metadata, or notification-content handling issues as security-sensitive until they are triaged.

## Reporting a Vulnerability

Do not open a public issue with vulnerability details, secrets, tokens, credentials, private logs, or notification payloads that contain sensitive content.

Use GitHub's private vulnerability reporting flow for this repository when it is available. If GitHub does not offer a private reporting button, open a minimal public issue asking for a private contact path and omit technical details until a private channel exists.

Useful initial context for a private report:

- affected version or commit
- platform and Zig version
- affected API surface (`zig_notify.h`, Zig package API, macOS osascript backend, Linux libnotify backend, build/package metadata, or docs)
- minimal reproduction, if it can be shared safely
- whether the issue affects confidentiality, integrity, availability, command construction, or API misuse risk

## Supported Versions

Security fixes target the latest released version and `main`. Older tags may receive follow-up notes when a vulnerability is confirmed, but active fixes should be developed against current `main`.
