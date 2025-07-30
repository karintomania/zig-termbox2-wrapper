// Wrapper for termbox2 header file.
// This file will hold the implementation part (inside #ifdef TB_IMPL) of termbox2.h.
// See here for the hack to run single-header c
// https://ziggit.dev/t/using-a-single-header-c-library-from-zig/1913/9
#define TB_IMPL
#define TB_OPT_ATTR_W 64
#define TB_OPT_EGC
#include "termbox2.h"
