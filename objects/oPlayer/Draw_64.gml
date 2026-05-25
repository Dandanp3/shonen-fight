if (!special_menu_open || array_length(specials) == 0) exit;

var _gw    = display_get_gui_width();
var _gh    = display_get_gui_height();
var _count = array_length(specials);

var _item_h   = floor(_gh * 0.048);
var _item_gap = 16;
var _menu_w   = floor(_gw * 0.20);
var _badge_w  = _item_h;
var _margin   = _gw * 0.018;
var _menu_x   = (pid == 1) ? _margin : _gw - _margin - _menu_w;
var _total_h  = _count * (_item_h + _item_gap) - _item_gap;
var _menu_y   = _gh * 0.44 - _total_h * 0.5;

var _accent   = (pid == 1) ? make_colour_rgb(40, 150, 255) : make_colour_rgb(255, 50, 130);
var _bg_col   = (pid == 1) ? make_colour_rgb(8, 16, 42)    : make_colour_rgb(42, 8, 22);
var _bd_col   = (pid == 1) ? make_colour_rgb(30, 70, 160)  : make_colour_rgb(160, 30, 80);
var _badge_bg = (pid == 1) ? make_colour_rgb(15, 40, 100)  : make_colour_rgb(100, 15, 50);
var _tag_bg   = (pid == 1) ? make_colour_rgb(10, 25, 70)   : make_colour_rgb(70, 10, 35);

// Label acima
draw_set_font(-1);
draw_set_color(_accent);
draw_set_alpha(0.7);
draw_set_valign(fa_bottom);
if (pid == 1) { draw_set_halign(fa_left);  draw_text(_menu_x, _menu_y - 4, "ESPECIAIS"); }
else          { draw_set_halign(fa_right); draw_text(_menu_x + _menu_w, _menu_y - 4, "ESPECIAIS"); }
draw_set_alpha(1);

for (var _i = 0; _i < _count; _i++) {
    var _sp   = specials[_i];
    var _iy   = floor(_menu_y + _i * (_item_h + _item_gap));
    var _ix2  = _menu_x + _menu_w;
    var _pode = (special_points >= _sp.cost);
    var _alpha_item = _pode ? 0.92 : 0.38;

    draw_set_alpha(_alpha_item);

    // Fundo do item — largura se expande pro nome caber
    draw_set_font(-1);
    var _nome_w   = string_width(_sp.name);
    var _needed_w = _badge_w + 16 + _nome_w + 12;
    var _iw       = max(_menu_w, _needed_w);
    var _ix2_real = (pid == 1) ? _menu_x + _iw : _menu_x + _menu_w;
    var _ix1_real = (pid == 1) ? _menu_x        : _menu_x + _menu_w - _iw;

    draw_set_color(_bg_col);
    draw_roundrect(_ix1_real, _iy, _ix2_real, _iy + _item_h, false);

    draw_set_color(_pode ? _bd_col : make_colour_rgb(100, 20, 20));
    draw_roundrect(_ix1_real, _iy, _ix2_real, _iy + _item_h, true);

    // Badge
    var _bx = (pid == 1) ? _ix1_real : _ix2_real - _badge_w;
    draw_set_color(_pode ? _badge_bg : make_colour_rgb(20, 20, 20));
    draw_roundrect(_bx, _iy, _bx + _badge_w, _iy + _item_h, false);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_pode ? _accent : make_colour_rgb(80, 80, 80));
    draw_text(_bx + _badge_w * 0.5, _iy + _item_h * 0.5, _sp.button_label);

    // Nome
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    if (pid == 1) {
        draw_set_halign(fa_left);
        draw_text(_ix1_real + _badge_w + 8, _iy + _item_h * 0.5, _sp.name);
    } else {
        draw_set_halign(fa_right);
        draw_text(_ix2_real - _badge_w - 8, _iy + _item_h * 0.5, _sp.name);
    }

    // Tag de custo 
    var _cost_str = "CUSTO: " + string(_sp.cost) + " SP";
    var _tag_pad  = 10;
    var _tag_h    = 13;
    var _tag_y    = _iy + _item_h + 2;
    var _tag_w    = string_width(_cost_str) + _tag_pad * 2;
    var _tag_x    = (pid == 1) ? _ix1_real : _ix2_real - _tag_w;

    draw_set_color(_tag_bg);
    draw_roundrect(_tag_x, _tag_y, _tag_x + _tag_w, _tag_y + _tag_h, false);
    draw_set_color(_pode ? _accent : make_colour_rgb(150, 50, 50));
    draw_roundrect(_tag_x, _tag_y, _tag_x + _tag_w, _tag_y + _tag_h, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_pode ? _accent : make_colour_rgb(180, 60, 60));
    draw_text(_tag_x + _tag_w * 0.5, _tag_y + _tag_h * 0.5, _cost_str);

    draw_set_alpha(1);
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);