const std = @import("std");
const ztb = @import("ztb");

pub fn main() !void {
    // initialize & shutdown
    try ztb.init();
    defer ztb.shutdown();

    // get terminal information
    const w = ztb.width();
    const h = ztb.height();

    const middleX: i32 = @divTrunc(w, 2);
    const middleY: i32 = @divTrunc(h, 2);

    try ztb.print(middleX, middleY-4, ztb.DEFAULT, ztb.DEFAULT, "Hello termbox2!");
    try ztb.print(middleX, middleY-2, ztb.BLUE | ztb.BOLD, ztb.DEFAULT, "Bold");
    try ztb.print(middleX, middleY-1, ztb.RED | ztb.UNDERLINE, ztb.DEFAULT, "Underline");
    try ztb.print(middleX, middleY+0, ztb.YELLOW | ztb.STRIKEOUT, ztb.DEFAULT, "Strikeout");
    try ztb.print(middleX, middleY+1, ztb.GREEN | ztb.ITALIC, ztb.DEFAULT, "Italic");
    try ztb.print(middleX, middleY+2, ztb.DEFAULT, ztb.DEFAULT, "Emoji ⚡");
    try ztb.print(middleX, middleY+4, ztb.DEFAULT | ztb.BOLD, ztb.DEFAULT, "Press any key...");
    try ztb.setCursor(middleX + 16, middleY + 4);

    // reflect the change
    try ztb.present();

    // get events
    var ev = ztb.newEvent();
    try ztb.pollEvent(&ev);

    try ztb.clear();
    try ztb.hideCursor();

    try ztb.printf(middleX, middleY - 1, ztb.CYAN, ztb.DEFAULT, "Event type: {d}", .{ev.type});
    try ztb.printf(middleX, middleY, ztb.CYAN, ztb.DEFAULT, "Key: {d}", .{ev.key});

    if (33 <= ev.ch and ev.ch <= 126) { // printable ASCII
        const ch: u8 = @as(u8, @intCast(ev.ch));
        try ztb.printf(middleX, middleY + 1, ztb.CYAN, ztb.DEFAULT, "Ch:  {c}", .{ch});
    }

    try ztb.print(middleX, middleY + 3, ztb.WHITE, ztb.DEFAULT, "Press any key to quit.");

    try ztb.present();

    try ztb.pollEvent(&ev);
}
