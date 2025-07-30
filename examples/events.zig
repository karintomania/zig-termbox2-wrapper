const std = @import("std");
const ztb = @import("ztb");

pub fn main() !void {
    // initialize & shutdown
    try ztb.init();
    defer ztb.shutdown();

    // set input mode
    // Available modes are INPUT_ESC and INPUT_ALT.
    // You can OR INPUT_MOUSE if you want to capture mouse events
    ztb.setInputMode(ztb.INPUT_ESC | ztb.INPUT_MOUSE);

    try showInstruction();
    try ztb.present();

    var ev: ztb.Event = ztb.newEvent();
    while (true) {
        try ztb.pollEvent(&ev);
        try ztb.clear();
        try showInstruction();

        switch (ev.type) {
            ztb.EVENT_KEY => {
                if (ev.key == ztb.KEY_CTRL_C or ev.key == ztb.KEY_ESC) {
                    // Finish the loop
                    break;
                }
                if (33 <= ev.ch and ev.ch <= 126) { // printable ASCII
                    const ch = @as(u8, @intCast(ev.ch));
                    try ztb.printf(0, 2, ztb.BLUE, ztb.DEFAULT, "Pressed: {c}", .{ch});
                }
            },

            ztb.EVENT_RESIZE => {
                const w = ev.w;
                const h = ev.h;
                try ztb.printf(@divTrunc(w, 2) - 10, @divTrunc(h, 2), ztb.BLUE, ztb.DEFAULT, "Resized. w:{d}, h:{d}", .{w, h});
            },

            ztb.EVENT_MOUSE => {
                const x: i32 = ev.x;
                const y: i32 = ev.y;

                switch (ev.key) {
                    ztb.KEY_MOUSE_LEFT, ztb.KEY_MOUSE_RIGHT, ztb.KEY_MOUSE_MIDDLE, ztb.KEY_MOUSE_WHEEL_DOWN, ztb.KEY_MOUSE_WHEEL_UP  => {
                        var message: []const u8 = "";
                        var colour: u64 = ztb.WHITE;

                        switch  (ev.key) {
                            ztb.KEY_MOUSE_LEFT  => {
                                message="Left Click";
                                colour=ztb.BLUE;
                            },
                            ztb.KEY_MOUSE_RIGHT => {
                                message="Right Click"; 
                                colour=ztb.RED;
                            },
                            ztb.KEY_MOUSE_MIDDLE => {
                                message="Middle Click"; 
                                colour=ztb.YELLOW;
                            },
                            ztb.KEY_MOUSE_WHEEL_UP => {
                                message="Scroll Up"; 
                                colour=ztb.MAGENTA;
                            },
                            ztb.KEY_MOUSE_WHEEL_DOWN => {
                                message="Scroll Down"; 
                                colour=ztb.CYAN;
                            },
                            else => {},
                        }

                        try ztb.print(x, y, colour|ztb.REVERSE, ztb.DEFAULT, message);
                    },
                    else => {
                        // ignore mouse release
                        continue;
                    },
                }
            },
            else => {
                try ztb.print(0, 2, ztb.RED, ztb.DEFAULT, "Unhandled Event Detected.");
            },
        }
        try ztb.present();
    }
}

fn showInstruction() !void {
    try ztb.print(0, 0, ztb.WHITE, ztb.HI_BLACK, "Press any keys, use mouse or resize the window...");
    try ztb.print(0, 1, ztb.WHITE, ztb.HI_BLACK, "Ctrl+C or ESC to quit");
    try ztb.setCursor(48, 0);
}
