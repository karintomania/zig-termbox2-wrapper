// This file is only for testing purpose
#define TB_IMPL
#define TB_OPT_ATTR_W 64
#define TB_OPT_EGC
#include "termbox2.h"
#include "locale.h"

int main() {
    setlocale(LC_ALL, "");

    tb_init();

    size_t w;

    tb_print(0,0,TB_DEFAULT, TB_DEFAULT, "emoji 🧑‍💻");
    tb_present();

    struct tb_event ev;

    tb_poll_event(&ev);

    tb_clear();

    // if I add those lines, the emoji works.
    // tb_print(0,0,TB_DEFAULT, TB_DEFAULT, "          ");
    // tb_present();

    tb_print(0,0,TB_DEFAULT, TB_DEFAULT, "emoji 👩‍💻");
    tb_present();

    tb_poll_event(&ev);

    tb_shutdown();
}
