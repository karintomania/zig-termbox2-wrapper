# zig termbox2 wrapper

This repo is a wrapper for https://github.com/termbox/termbox2.
I intend to simply expose the original functions to zig as-is and nothing more.

# Dependencies

This repo uses `termbox2`. Also, it dynamically links `libc`.

# Example

Clone this repo and run `zig build simple` to run a simple example program.
The source code for it is `examples/simple.zig`.

# How to Use

Run the command below inside your project:
```
zig fetch --save git+https://github.com/karintomania/zig-termbox2-wrapper
```

Add the code below to your `build.zig` after the declaration of `const exe`.
I'm naming it `ztb` (as zig termbox) because `zig_termbox2_wrapper` would be too long. You can name it whatever you want, though.
```
    const ztb = b.dependency("zig_termbox2_wrapper", .{
        .target = target,
        .optimize = optimize,
    });

    exe.root_module.addImport("ztb", ztb.module("zig_termbox2_wrapper"));
```

This should allow you to import the `ztb` module inside your code.
```
// inside your code
const ztb = @import("ztb");
```

## License

This wrapper uses termbox2, which is licensed under the MIT License:

```
MIT License

Copyright (c) 2021 termbox developers

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
