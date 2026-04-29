//! Public Zig package API for zig-notify.
//!
//! C ABI consumers should include `include/zig_notify.h` and link the static
//! library. Zig package consumers import this module and call the same
//! platform-dispatched notification functions directly.

pub const notify = @import("notify.zig");

pub const Urgency = notify.Urgency;
pub const send = notify.send;
pub const init = notify.init;
pub const deinit = notify.deinit;

test {
    _ = Urgency.normal;
    _ = send;
    _ = init;
    _ = deinit;
}
