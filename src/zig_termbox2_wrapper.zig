const std = @import("std");
const c = @cImport({
    @cDefine("TB_OPT_ATTR_W", "32");
    @cInclude("termbox2.h");
    @cInclude("locale.h");
});

pub fn init() !void {
    // set locale to print non-ASCII chars
    _ = c.setlocale(c.LC_ALL, "");

    const result = c.tb_init();
    if (result != 0) return error.InitFailed;
}

pub fn shutdown() void {
    _ = c.tb_shutdown();
}

pub fn width() i32 {
    return c.tb_width();
}

pub fn height() i32 {
    return c.tb_height();
}

pub fn clear() !void {
    const result = c.tb_clear();
    if (result != 0) return error.ClearFailed;
}

pub fn present() !void {
    const result = c.tb_present();
    if (result != 0) return error.PresentFailed;
}

pub fn setCursor(cx: i32, cy: i32) !void {
    const result = c.tb_set_cursor(cx, cy);
    if (result != 0) return error.SetCursorFailed;
}

pub fn hideCursor() !void {
    const result = c.tb_hide_cursor();
    if (result != 0) return error.HideCursorFailed;
}

pub fn setCell(x: i32, y: i32, ch: u32, fg: u32, bg: u32) !void {
    const result = c.tb_set_cell(x, y, ch, fg, bg);
    if (result != 0) return error.SetCellFailed;
}

pub fn setCellEx(x: i32, y: i32, ch: []const u32, fg: u32, bg: u32) !void {
    const result = c.tb_set_cell_ex(x, y, @ptrCast(@constCast(ch.ptr)), ch.len, fg, bg);
    if (result != 0) return error.SetCellFailed;
}

pub fn setCellUnicode(x: i32, y: i32, str: []const u8, fg: u32, bg: u32) !void {
    var codepoints: [16]u32 = undefined;
    var i: usize = 0;
    var idx: usize = 0;

    while (i < str.len and idx < codepoints.len) {
        const len = std.unicode.utf8ByteSequenceLength(str[i]) catch return error.InvalidUTF8;
        if (i + len > str.len) return error.InvalidUTF8;

        const codepoint = std.unicode.utf8Decode(str[i .. i + len]) catch return error.InvalidUTF8;
        codepoints[idx] = codepoint;
        i += len;
        idx += 1;
    }

    if (idx == 0) return error.EmptyString;
    try setCellEx(x, y, codepoints[0..idx], fg, bg);
}

pub const Event = c.tb_event;

pub fn newEvent() Event {
    return std.mem.zeroes(Event);
}

pub fn peekEvent(event: *Event, timeout_ms: i32) !bool {
    const result = c.tb_peek_event(event, timeout_ms);
    if (result < 0) return error.PeekEventFailed;
    return result > 0;
}

pub fn pollEvent(event: *Event) !void {
    const result = c.tb_poll_event(event);
    if (result != 0) return error.PollEventFailed;
}

pub fn print(x: i32, y: i32, fg: u32, bg: u32, str: []const u8) !void {
    var buf: [1024]u8 = undefined;
    if (str.len >= buf.len) return error.StringTooLong;

    @memcpy(buf[0..str.len], str);
    buf[str.len] = 0; // null terminate

    var w: usize = 0;
    const result = c.tb_print_ex(x, y, fg, bg, &w, &buf);
    if (result != 0) return error.PrintFailed;
}

pub fn printf(x: i32, y: i32, fg: u32, bg: u32, comptime fmt: []const u8, args: anytype) !void {
    var buf: [1024]u8 = undefined;
    const formatted = try std.fmt.bufPrint(&buf, fmt, args);
    try print(x, y, fg, bg, formatted);
}

pub fn hasEgc() bool {
    return c.tb_has_egc() != 0;
}

// Key constants
pub const KEY_CTRL_TILDE = c.TB_KEY_CTRL_TILDE;
pub const KEY_CTRL_2 = c.TB_KEY_CTRL_2;
pub const KEY_CTRL_A = c.TB_KEY_CTRL_A;
pub const KEY_CTRL_B = c.TB_KEY_CTRL_B;
pub const KEY_CTRL_C = c.TB_KEY_CTRL_C;
pub const KEY_CTRL_D = c.TB_KEY_CTRL_D;
pub const KEY_CTRL_E = c.TB_KEY_CTRL_E;
pub const KEY_CTRL_F = c.TB_KEY_CTRL_F;
pub const KEY_CTRL_G = c.TB_KEY_CTRL_G;
pub const KEY_BACKSPACE = c.TB_KEY_BACKSPACE;
pub const KEY_CTRL_H = c.TB_KEY_CTRL_H;
pub const KEY_TAB = c.TB_KEY_TAB;
pub const KEY_CTRL_I = c.TB_KEY_CTRL_I;
pub const KEY_CTRL_J = c.TB_KEY_CTRL_J;
pub const KEY_CTRL_K = c.TB_KEY_CTRL_K;
pub const KEY_CTRL_L = c.TB_KEY_CTRL_L;
pub const KEY_ENTER = c.TB_KEY_ENTER;
pub const KEY_CTRL_M = c.TB_KEY_CTRL_M;
pub const KEY_CTRL_N = c.TB_KEY_CTRL_N;
pub const KEY_CTRL_O = c.TB_KEY_CTRL_O;
pub const KEY_CTRL_P = c.TB_KEY_CTRL_P;
pub const KEY_CTRL_Q = c.TB_KEY_CTRL_Q;
pub const KEY_CTRL_R = c.TB_KEY_CTRL_R;
pub const KEY_CTRL_S = c.TB_KEY_CTRL_S;
pub const KEY_CTRL_T = c.TB_KEY_CTRL_T;
pub const KEY_CTRL_U = c.TB_KEY_CTRL_U;
pub const KEY_CTRL_V = c.TB_KEY_CTRL_V;
pub const KEY_CTRL_W = c.TB_KEY_CTRL_W;
pub const KEY_CTRL_X = c.TB_KEY_CTRL_X;
pub const KEY_CTRL_Y = c.TB_KEY_CTRL_Y;
pub const KEY_CTRL_Z = c.TB_KEY_CTRL_Z;
pub const KEY_ESC = c.TB_KEY_ESC;
pub const KEY_CTRL_LSQ_BRACKET = c.TB_KEY_CTRL_LSQ_BRACKET;
pub const KEY_CTRL_3 = c.TB_KEY_CTRL_3;
pub const KEY_CTRL_4 = c.TB_KEY_CTRL_4;
pub const KEY_CTRL_BACKSLASH = c.TB_KEY_CTRL_BACKSLASH;
pub const KEY_CTRL_5 = c.TB_KEY_CTRL_5;
pub const KEY_CTRL_RSQ_BRACKET = c.TB_KEY_CTRL_RSQ_BRACKET;
pub const KEY_CTRL_6 = c.TB_KEY_CTRL_6;
pub const KEY_CTRL_7 = c.TB_KEY_CTRL_7;
pub const KEY_CTRL_SLASH = c.TB_KEY_CTRL_SLASH;
pub const KEY_CTRL_UNDERSCORE = c.TB_KEY_CTRL_UNDERSCORE;
pub const KEY_SPACE = c.TB_KEY_SPACE;
pub const KEY_BACKSPACE2 = c.TB_KEY_BACKSPACE2;
pub const KEY_CTRL_8 = c.TB_KEY_CTRL_8;
pub const KEY_F1 = c.TB_KEY_F1;
pub const KEY_F2 = c.TB_KEY_F2;
pub const KEY_F3 = c.TB_KEY_F3;
pub const KEY_F4 = c.TB_KEY_F4;
pub const KEY_F5 = c.TB_KEY_F5;
pub const KEY_F6 = c.TB_KEY_F6;
pub const KEY_F7 = c.TB_KEY_F7;
pub const KEY_F8 = c.TB_KEY_F8;
pub const KEY_F9 = c.TB_KEY_F9;
pub const KEY_F10 = c.TB_KEY_F10;
pub const KEY_F11 = c.TB_KEY_F11;
pub const KEY_F12 = c.TB_KEY_F12;
pub const KEY_INSERT = c.TB_KEY_INSERT;
pub const KEY_DELETE = c.TB_KEY_DELETE;
pub const KEY_HOME = c.TB_KEY_HOME;
pub const KEY_END = c.TB_KEY_END;
pub const KEY_PGUP = c.TB_KEY_PGUP;
pub const KEY_PGDN = c.TB_KEY_PGDN;
pub const KEY_ARROW_UP = c.TB_KEY_ARROW_UP;
pub const KEY_ARROW_DOWN = c.TB_KEY_ARROW_DOWN;
pub const KEY_ARROW_LEFT = c.TB_KEY_ARROW_LEFT;
pub const KEY_ARROW_RIGHT = c.TB_KEY_ARROW_RIGHT;
pub const KEY_BACK_TAB = c.TB_KEY_BACK_TAB;
pub const KEY_MOUSE_LEFT = c.TB_KEY_MOUSE_LEFT;
pub const KEY_MOUSE_RIGHT = c.TB_KEY_MOUSE_RIGHT;
pub const KEY_MOUSE_MIDDLE = c.TB_KEY_MOUSE_MIDDLE;
pub const KEY_MOUSE_RELEASE = c.TB_KEY_MOUSE_RELEASE;
pub const KEY_MOUSE_WHEEL_UP = c.TB_KEY_MOUSE_WHEEL_UP;
pub const KEY_MOUSE_WHEEL_DOWN = c.TB_KEY_MOUSE_WHEEL_DOWN;

// Colors
pub const DEFAULT = c.TB_DEFAULT;
pub const BLACK = c.TB_BLACK;
pub const RED = c.TB_RED;
pub const GREEN = c.TB_GREEN;
pub const YELLOW = c.TB_YELLOW;
pub const BLUE = c.TB_BLUE;
pub const MAGENTA = c.TB_MAGENTA;
pub const CYAN = c.TB_CYAN;
pub const WHITE = c.TB_WHITE;

// Attributes
pub const BOLD = c.TB_BOLD;
pub const UNDERLINE = c.TB_UNDERLINE;
pub const REVERSE = c.TB_REVERSE;
pub const ITALIC = c.TB_ITALIC;
pub const BLINK = c.TB_BLINK;
pub const HI_BLACK = c.TB_HI_BLACK;
pub const BRIGHT = c.TB_BRIGHT;
pub const DIM = c.TB_DIM;
pub const STRIKEOUT = c.TB_STRIKEOUT;
pub const UNDERLINE_2 = c.TB_UNDERLINE_2;
pub const OVERLINE = c.TB_OVERLINE;
pub const INVISIBLE = c.TB_INVISIBLE;

// Event types
pub const EVENT_KEY = c.TB_EVENT_KEY;
pub const EVENT_RESIZE = c.TB_EVENT_RESIZE;
pub const EVENT_MOUSE = c.TB_EVENT_MOUSE;

// Modifiers
pub const MOD_ALT = c.TB_MOD_ALT;
pub const MOD_CTRL = c.TB_MOD_CTRL;
pub const MOD_SHIFT = c.TB_MOD_SHIFT;
pub const MOD_MOTION = c.TB_MOD_MOTION;

// Input modes
pub const INPUT_CURRENT = c.TB_INPUT_CURRENT;
pub const INPUT_ESC = c.TB_INPUT_ESC;
pub const INPUT_ALT = c.TB_INPUT_ALT;
pub const INPUT_MOUSE = c.TB_INPUT_MOUSE;

// Output modes
pub const OUTPUT_CURRENT = c.TB_OUTPUT_CURRENT;
pub const OUTPUT_NORMAL = c.TB_OUTPUT_NORMAL;
pub const OUTPUT_256 = c.TB_OUTPUT_256;
pub const OUTPUT_216 = c.TB_OUTPUT_216;
pub const OUTPUT_GRAYSCALE = c.TB_OUTPUT_GRAYSCALE;
pub const OUTPUT_TRUECOLOR = c.TB_OUTPUT_TRUECOLOR;
