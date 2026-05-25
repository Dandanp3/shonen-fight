function assign_gamepads() {
    global.p1_gamepad = noone;
    global.p2_gamepad = noone;
    
    var _count = 0;
    var _slots = gamepad_get_device_count();
    
    // Arrays para guardar o que já foi mapeado de verdade
    var _assigned_slots = [];
    var _assigned_descs = [];

    for (var _i = 0; _i < _slots; _i++) {
        if (gamepad_is_connected(_i)) {
            var _desc = gamepad_get_description(_i);
            var _is_ghost = false;
            
            // ANTI-FANTASMA: Se o slot atual for DirectInput (>= 4), checa se 
            // já pegamos esse mesmo controle como XInput (0-3) para não duplicar.
            if (_i >= 4) {
                for (var _j = 0; _j < array_length(_assigned_slots); _j++) {
                    if (_assigned_descs[_j] == _desc && _assigned_slots[_j] < 4) {
                        _is_ghost = true;
                        break;
                    }
                }
            }
            
            if (_is_ghost) continue; // Pula o clone fantasma e vai para o próximo!

            // Mapeia os jogadores reais
            if (_count == 0) {
                global.p1_gamepad = _i;
                array_push(_assigned_slots, _i);
                array_push(_assigned_descs, _desc);
                _count++;
            } else if (_count == 1) {
                global.p2_gamepad = _i;
                array_push(_assigned_slots, _i);
                array_push(_assigned_descs, _desc);
                _count++;
                break; // Já achou os dois controles físicos diferentes, encerra.
            }
        }
    }
}
function get_player_input(pid) {
    var _gp  = (pid == 1) ? global.p1_gamepad : global.p2_gamepad;
    var _has = (_gp != noone) && gamepad_is_connected(_gp);

    var _inp = {
        right:        false,
        left:         false,
        jump:         false,
        attack:       false,
        attack_held:  false,
        special:      false
    };

    if (pid == 1) {
        _inp.right       = keyboard_check(ord("D"))
                           || (_has && gamepad_axis_value(_gp, gp_axislh) > 0.25);
        _inp.left        = keyboard_check(ord("A"))
                           || (_has && gamepad_axis_value(_gp, gp_axislh) < -0.25);
        _inp.jump        = keyboard_check_pressed(vk_space)
                           || (_has && gamepad_button_check_pressed(_gp, gp_face1));
        _inp.attack      = mouse_check_button_pressed(mb_left)
                           || (_has && gamepad_button_check_pressed(_gp, gp_face3));
        _inp.attack_held = mouse_check_button(mb_left)
                           || (_has && gamepad_button_check(_gp, gp_face3));
        _inp.special     = keyboard_check(ord("G"))
                           || (_has && gamepad_button_check_pressed(_gp, gp_shoulderl));
    } else {
        _inp.right       = keyboard_check(vk_right)
                           || (_has && gamepad_axis_value(_gp, gp_axislh) > 0.25);
        _inp.left        = keyboard_check(vk_left)
                           || (_has && gamepad_axis_value(_gp, gp_axislh) < -0.25);
        _inp.jump        = keyboard_check_pressed(vk_up)
                           || (_has && gamepad_button_check_pressed(_gp, gp_face1));
        _inp.attack      = keyboard_check_pressed(vk_numpad1)
                           || (_has && gamepad_button_check_pressed(_gp, gp_face3));
        _inp.attack_held = keyboard_check(vk_numpad1)
                           || (_has && gamepad_button_check(_gp, gp_face3));
        _inp.special     = keyboard_check(vk_numpad0)
                           || (_has && gamepad_button_check_pressed(_gp, gp_shoulderl));
    }

    return _inp;
}