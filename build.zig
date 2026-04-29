const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const ffi_module = b.createModule(.{
        .root_source_file = b.path("src/ffi.zig"),
        .target = target,
        .optimize = optimize,
    });
    addLinuxNotifyDeps(ffi_module, target);

    // Zig module for package manager consumers.
    const zig_module = b.addModule("zig-notify", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    addLinuxNotifyDeps(zig_module, target);

    // Static library for C FFI consumers.
    const lib = b.addLibrary(.{
        .name = "zig-notify",
        .root_module = ffi_module,
        .linkage = .static,
    });

    b.installArtifact(lib);

    // Documentation generation.
    const docs_step = b.step("docs", "Generate API documentation");
    const install_docs = b.addInstallDirectory(.{
        .source_dir = lib.getEmittedDocs(),
        .install_dir = .prefix,
        .install_subdir = "docs",
    });
    docs_step.dependOn(&install_docs.step);

    // C example. Build only: running it sends a real desktop notification.
    const example_step = b.step("example", "Build the C example");
    const example_module = b.createModule(.{
        .target = target,
        .optimize = optimize,
    });
    example_module.link_libc = true;
    example_module.addIncludePath(b.path("include"));
    example_module.addCSourceFile(.{
        .file = b.path("examples/send_notification.c"),
        .flags = &.{ "-std=c99", "-Wall", "-Wextra" },
    });
    example_module.linkLibrary(lib);
    addLinuxNotifyDeps(example_module, target);

    const example = b.addExecutable(.{
        .name = "send_notification",
        .root_module = example_module,
    });
    example_step.dependOn(&example.step);

    const test_step = b.step("test", "Run unit tests");
    inline for (.{
        "src/root.zig",
        "src/notify.zig",
    }) |test_file| {
        const test_module = b.createModule(.{
            .root_source_file = b.path(test_file),
            .target = target,
            .optimize = optimize,
        });
        addLinuxNotifyDeps(test_module, target);
        const t = b.addTest(.{
            .root_module = test_module,
        });
        test_step.dependOn(&b.addRunArtifact(t).step);
    }
}

fn addLinuxNotifyDeps(module: *std.Build.Module, target: std.Build.ResolvedTarget) void {
    if (target.result.os.tag != .linux) return;

    module.link_libc = true;
    module.linkSystemLibrary("notify", .{});
    module.linkSystemLibrary("glib-2.0", .{});
    module.linkSystemLibrary("gobject-2.0", .{});

    // Paths vary by distro. addSystemIncludePath ignores missing directories.
    module.addSystemIncludePath(.{ .cwd_relative = "/usr/include/libnotify" });
    module.addSystemIncludePath(.{ .cwd_relative = "/usr/include/glib-2.0" });
    module.addSystemIncludePath(.{ .cwd_relative = "/usr/include/gdk-pixbuf-2.0" });
    module.addSystemIncludePath(.{ .cwd_relative = "/usr/lib/x86_64-linux-gnu/glib-2.0/include" });
    module.addSystemIncludePath(.{ .cwd_relative = "/usr/lib/aarch64-linux-gnu/glib-2.0/include" });
    module.addSystemIncludePath(.{ .cwd_relative = "/usr/lib64/glib-2.0/include" });
    module.addSystemIncludePath(.{ .cwd_relative = "/usr/lib/glib-2.0/include" });
}
