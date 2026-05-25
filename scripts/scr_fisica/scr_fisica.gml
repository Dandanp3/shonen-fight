#macro GRAVIDADE 0.3

function inicia_fisica(_massa_inicial) {
    self.hspd  = 0;
    self.vspd  = 0;
    self.massa = _massa_inicial;
}

function aplica_fisica_e_colisao() {
    if (!variable_instance_exists(id, "vspd")  || is_undefined(vspd))  vspd  = 0;
    if (!variable_instance_exists(id, "hspd")  || is_undefined(hspd))  hspd  = 0;
    if (!variable_instance_exists(id, "massa") || is_undefined(massa)) massa = 1;

    vspd += GRAVIDADE * massa;

    // Colisão horizontal
    if (place_meeting(x + hspd, y, obj_wall)) {
        while (!place_meeting(x + sign(hspd), y, obj_wall)) {
            x += sign(hspd);
        }
        hspd = 0;
    }
    x += hspd;

    // Colisão vertical
    if (place_meeting(x, y + vspd, obj_wall)) {
        while (!place_meeting(x, y + sign(vspd), obj_wall)) {
            y += sign(vspd);
        }
        vspd = 0;
    }
    y += vspd;

    // Limites da room (só impede de sair por baixo e pelos lados)
    x = clamp(x, 0, room_width);
    y = min(y, room_height);
}