// ═══════════════════════════════════════════════════════════
//  HUD PRINCIPAL — Draw GUI (oHUD)
// ═══════════════════════════════════════════════════════════
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _p1 = noone, _p2 = noone;
with (oPlayer) {
    if (pid == 1) _p1 = id;
    if (pid == 2) _p2 = id;
}

// ── LAYOUT ───────────────────────────────────────────────────
var _pad      = _gw * 0.018;
var _bar_w    = _gw * 0.34;
var _bar_h    = floor(_gh * 0.022);
var _sp_h     = floor(_gh * 0.009);
var _bar_y    = floor(_gh * 0.022);
var _sp_y     = _bar_y + _bar_h + 4;
var _gem_y    = _sp_y + _sp_h + 5;
var _gem_size = floor(_gh * 0.013);
var _gem_gap  = 4;

// Pulso de urgência (HP baixo)
var _pulse_alpha = (0.45 + (sin(current_time * 0.012) + 1) * 0.275);

// ── MACROS DE COR ─────────────────────────────────────────────
#macro HP_COL_HIGH   make_colour_rgb(40, 200, 90)
#macro HP_COL_MID    make_colour_rgb(220, 170, 0)
#macro HP_COL_LOW    make_colour_rgb(220, 50, 20)
#macro COL_SP_P1     make_colour_rgb(40, 160, 255)
#macro COL_SP_P2     make_colour_rgb(255, 60, 140)
#macro COL_BG_DARK   make_colour_rgb(12, 12, 22)
#macro COL_BG_TRACK  make_colour_rgb(18, 18, 30)
#macro COL_BORDER    make_colour_rgb(40, 40, 70)
#macro COL_GEM_EMPTY make_colour_rgb(30, 30, 50)

// ── TIMER (CENTRO) ────────────────────────────────────────────
var _tc_x = _gw * 0.5;
var _tc_y = _bar_y;
var _tw   = 64;
var _th   = _bar_h + _sp_h + 10;

draw_set_alpha(1);
draw_set_color(COL_BG_DARK);
draw_roundrect(_tc_x - _tw*0.5, _tc_y - 4, _tc_x + _tw*0.5, _tc_y + _th, false);
draw_set_color(COL_BORDER);
draw_roundrect(_tc_x - _tw*0.5, _tc_y - 4, _tc_x + _tw*0.5, _tc_y + _th, true);

draw_set_font(-1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(1);
draw_set_color(make_colour_rgb(220, 215, 255));
draw_text(_tc_x, _tc_y + _th * 0.5 - 1, "99");
draw_set_alpha(1);

// Round pips abaixo do timer
var _pip_r   = 5;
var _pip_gap = 6;
var _pip_y   = _tc_y + _th + 6;

for (var _r = 0; _r < 2; _r++) {
    var _px = _tc_x - (_pip_r*2 + _pip_gap) * (2 - _r) + _pip_gap;
    draw_set_color(COL_GEM_EMPTY);
    draw_circle(_px, _pip_y, _pip_r, false);
}
for (var _r = 0; _r < 2; _r++) {
    var _px = _tc_x + (_pip_r*2 + _pip_gap) * (_r + 1) - _pip_gap;
    draw_set_color(COL_GEM_EMPTY);
    draw_circle(_px, _pip_y, _pip_r, false);
}

// ── HELPER: barra de HP ───────────────────────────────────────
var _draw_hp_bar = function(_inst, _bx, _by, _bw, _bh, _mirror, _palpha) {
    var _pct  = clamp(_inst.hp / _inst.hp_max, 0, 1);
    var _low  = _pct <= 0.25;
    var _bg_a = _low ? _palpha : 1.0;

    draw_set_alpha(1);
    draw_set_color(COL_BG_TRACK);
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);

    var _hp_col;
    if (_pct > 0.5)       _hp_col = HP_COL_HIGH;
    else if (_pct > 0.25) _hp_col = HP_COL_MID;
    else                  _hp_col = HP_COL_LOW;

    draw_set_alpha(_low ? _bg_a : 1.0);
    draw_set_color(_hp_col);
    if (!_mirror) {
        draw_rectangle(_bx, _by, _bx + _bw * _pct, _by + _bh, false);
    } else {
        draw_rectangle(_bx + _bw * (1 - _pct), _by, _bx + _bw, _by + _bh, false);
    }

    // Brilho no topo
    draw_set_alpha(0.12);
    draw_set_color(c_white);
    draw_rectangle(_bx, _by, _bx + _bw, _by + floor(_bh * 0.35), false);

    // Borda
    draw_set_alpha(1);
    draw_set_color(COL_BORDER);
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);
};

// ── HELPER: barra de ESPECIAL ─────────────────────────────────
var _draw_sp_bar = function(_inst, _bx, _by, _bw, _bh, _mirror, _sp_col) {
    var _pct = clamp(_inst.special_energy / _inst.special_energy_max, 0, 1);

    draw_set_color(COL_BG_TRACK);
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);

    draw_set_color(_sp_col);
    if (!_mirror) {
        draw_rectangle(_bx, _by, _bx + _bw * _pct, _by + _bh, false);
    } else {
        draw_rectangle(_bx + _bw * (1 - _pct), _by, _bx + _bw, _by + _bh, false);
    }

    // Divisórias por stock
    draw_set_color(make_colour_rgb(0, 0, 0));
    draw_set_alpha(0.5);
    var _max_pts = _inst.special_points_max;
    for (var _t = 1; _t < _max_pts; _t++) {
        var _tx = _bx + (_bw / _max_pts) * _t;
        draw_rectangle(_tx - 1, _by, _tx + 1, _by + _bh, false);
    }
    draw_set_alpha(1);

    draw_set_color(COL_BORDER);
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);
};

// ── HELPER: gems de stock ─────────────────────────────────────
var _draw_gems = function(_inst, _gx, _gy, _gs, _gap, _gem_col, _mirror) {
    var _total = _inst.special_points_max;
    var _have  = _inst.special_points;
    var _dir   = _mirror ? -1 : 1;
    for (var _i = 0; _i < _total; _i++) {
        var _cx     = _gx + _dir * _i * (_gs + _gap);
        var _filled = _i < _have;
        draw_set_color(_filled ? _gem_col : COL_GEM_EMPTY);
        draw_rectangle(_cx, _gy, _cx + _gs, _gy + _gs, false);
        if (_filled) {
            draw_set_alpha(0.25);
            draw_set_color(c_white);
            draw_rectangle(_cx, _gy, _cx + _gs, _gy + floor(_gs * 0.4), false);
            draw_set_alpha(1);
        }
        draw_set_color(_filled ? merge_colour(COL_BORDER, _gem_col, 0.4) : COL_BORDER);
        draw_rectangle(_cx, _gy, _cx + _gs, _gy + _gs, true);
    }
};

// ── P1 ────────────────────────────────────────────────────────
if (instance_exists(_p1)) {
    var _bx1 = _pad;

    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
    draw_set_color(make_colour_rgb(200, 195, 255));
    draw_text(_bx1, _bar_y - 3, "P1  " + object_get_name(_p1.object_index));

    _draw_hp_bar(_p1, _bx1, _bar_y, _bar_w, _bar_h, false, _pulse_alpha);
    _draw_sp_bar(_p1, _bx1, _sp_y,  _bar_w, _sp_h,  false, COL_SP_P1);
    _draw_gems(  _p1, _bx1, _gem_y, _gem_size, _gem_gap, COL_SP_P1, false);
}

// ── P2 ────────────────────────────────────────────────────────
if (instance_exists(_p2)) {
    var _bx2 = _gw - _pad - _bar_w;

    draw_set_font(-1);
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_set_color(make_colour_rgb(255, 195, 220));
    draw_text(_gw - _pad, _bar_y - 3, object_get_name(_p2.object_index) + "  P2");

    _draw_hp_bar(_p2, _bx2, _bar_y, _bar_w, _bar_h, true,  _pulse_alpha);
    _draw_sp_bar(_p2, _bx2, _sp_y,  _bar_w, _sp_h,  true,  COL_SP_P2);
    _draw_gems(  _p2, _gw - _pad - _gem_size, _gem_y, _gem_size, _gem_gap, COL_SP_P2, true);
}

// Reset
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);