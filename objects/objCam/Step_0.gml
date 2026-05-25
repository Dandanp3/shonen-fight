cam_fixed_y = room_height - cam_height;

var _p1 = noone, _p2 = noone;
with (oPlayer) {
    if (pid == 1) _p1 = id;
    if (pid == 2) _p2 = id;
}

var _mid_x;
if (instance_exists(_p1) && instance_exists(_p2)) {
    _mid_x = (_p1.x + _p2.x) / 2;
} else if (instance_exists(_p1)) {
    _mid_x = _p1.x;
} else if (instance_exists(_p2)) {
    _mid_x = _p2.x;
} else {
    _mid_x = room_width / 2;
}

var _cam_x = clamp(_mid_x - cam_width / 2 + cam_offset_x, 0, max(0, room_width  - cam_width));
var _cam_y = clamp(cam_fixed_y + cam_offset_y,             0, max(0, room_height - cam_height));

// Screenshake
var _sx = 0, _sy = 0;
if (instance_exists(oScreenShake) && oScreenShake.shake_time > 0) {
    var _pow = oScreenShake.shake_power;
    _sx = irandom_range(-_pow, _pow);
    _sy = irandom_range(-_pow, _pow);
}

camera_set_view_pos(view_camera[0],
    clamp(_cam_x + _sx, 0, max(0, room_width  - cam_width)),
    clamp(_cam_y + _sy, 0, max(0, room_height - cam_height)));