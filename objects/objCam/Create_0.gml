cam_width  = 640;
cam_height = 480;

var _scale = 2;
window_set_size(cam_width * _scale, cam_height * _scale);
surface_resize(application_surface, cam_width * _scale, cam_height * _scale);

view_enabled    = true;
view_visible[0] = true;
camera_set_view_size(view_camera[0], cam_width, cam_height);

cam_offset_x = 0;
cam_offset_y = 0;

alarm[0] = 1;