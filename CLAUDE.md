# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Zig wrapper for termbox2, a terminal UI library. The project exposes the original termbox2 C API to Zig with minimal modifications, providing a simple interface for terminal-based applications.

## Architecture

- **Core wrapper**: `src/zig_termbox2_wrapper.zig` - Main Zig module that wraps termbox2 C functions
- **C library**: `c-src/` contains the original termbox2 source (`termbox2.c`, `termbox2.h`)
- **Module structure**: The wrapper uses `@cImport` to interface with C code and exposes Zig-friendly APIs
- **Error handling**: C return codes are converted to Zig errors (e.g., `InitFailed`, `ClearFailed`)

## Key Components

- **Initialization**: `init()` and `shutdown()` manage terminal state
- **Drawing**: `setCell()`, `setCellEx()`, `setCellUnicode()` for character placement
- **Text output**: `print()` and `printf()` for string rendering
- **Event handling**: `pollEvent()` and `peekEvent()` for keyboard/mouse input
- **Constants**: Extensive key, color, and attribute constants exposed from C

## Development Commands

- **Build library**: `zig build`
- **Run example**: `zig build simple` (runs `examples/simple.zig`)
- **Build requirements**: Zig 0.14.1+ (specified in `build.zig.zon`)

## Module Usage

The wrapper is exposed as a Zig module named "zig_termbox2_wrapper" that can be imported as `ztb`:

```zig
const ztb = @import("ztb");
```

The module requires linking with libc and includes the C source files automatically via the build system.