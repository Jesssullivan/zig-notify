const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const root_module = b.createModule(.{
        .root_source_file = b.path("src/ffi.zig"),
        .target = target,
        .optimize = optimize,
    });

    // On Linux, add system include paths for libnotify/glib/gdk-pixbuf.
    // Paths vary by distro — Debian/Ubuntu use multiarch triplets,
    // Fedora/RHEL/Rocky use /usr/lib64, Arch uses /usr/lib.
    // addSystemIncludePath silently ignores non-existent directories.
    const resolved_target = root_module.resolved_target.?;
    if (resolved_target.result.os.tag == .linux) {
        root_module.link_libc = true;
        root_module.addSystemIncludePath(.{ .cwd_relative = "/usr/include/libnotify" });
        root_module.addSystemIncludePath(.{ .cwd_relative = "/usr/include/glib-2.0" });
        root_module.addSystemIncludePath(.{ .cwd_relative = "/usr/include/gdk-pixbuf-2.0" });
        // Debian/Ubuntu multiarch
        root_module.addSystemIncludePath(.{ .cwd_relative = "/usr/lib/x86_64-linux-gnu/glib-2.0/include" });
        root_module.addSystemIncludePath(.{ .cwd_relative = "/usr/lib/aarch64-linux-gnu/glib-2.0/include" });
        // Fedora/RHEL/Rocky
        root_module.addSystemIncludePath(.{ .cwd_relative = "/usr/lib64/glib-2.0/include" });
        // Arch Linux
        root_module.addSystemIncludePath(.{ .cwd_relative = "/usr/lib/glib-2.0/include" });
    }

    const lib = b.addLibrary(.{
        .name = "zig-notify",
        .root_module = root_module,
        .linkage = .static,
    });

    b.installArtifact(lib);

    const test_step = b.step("test", "Run unit tests");
    const t = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/notify.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    test_step.dependOn(&b.addRunArtifact(t).step);
}
