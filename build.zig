const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const ztb_mod = b.addModule("zig_termbox2_wrapper", .{
        .root_source_file = b.path("src/zig_termbox2_wrapper.zig"),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    ztb_mod.addIncludePath(b.path("c-src"));
    ztb_mod.addCSourceFile(.{ .file = b.path("c-src/termbox2.c") });

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "ztb",
        .root_module = ztb_mod,
    });

    b.installArtifact(lib);

    // running step of simple example
    const simple_run_step = b.step("simple", "Run example/simple.zig");
    const simple = b.addExecutable(.{
        .name = "simple",
        .root_module = b.addModule("simple-example", .{
            .root_source_file = b.path("examples/simple.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    simple.root_module.addImport("ztb", ztb_mod);
    b.installArtifact(simple);
    const simple_run = b.addRunArtifact(simple);
    simple_run_step.dependOn(&simple_run.step);

    // running step of events example
    const events_run_step = b.step("events", "Run example/events.zig");
    const events = b.addExecutable(.{
        .name = "events",
        .root_module = b.addModule("event-example", .{
            .root_source_file = b.path("examples/events.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    events.root_module.addImport("ztb", ztb_mod);
    b.installArtifact(events);
    const events_run = b.addRunArtifact(events);
    events_run_step.dependOn(&events_run.step);
}
