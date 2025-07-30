// This file is only for testing purpose
#define TB_IMPL
#define TB_OPT_ATTR_W 64
#define TB_OPT_EGC
#include "termbox2.h"

int main() {
    tb_init();

    tb_print(0,0,TB_DEFAULT, TB_DEFAULT, "aa");
    tb_present();

    struct tb_event ev;

    tb_poll_event(&ev);

    tb_shutdown();
}
