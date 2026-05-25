if (inv_timer > 0) {
    inv_timer--;
}

// DEFINIÇÃO DE CONTROLES E INPUTS 
var _gp = (pid == 1) ? global.p1_gamepad : global.p2_gamepad;
var _hasgp = (_gp != noone) && gamepad_is_connected(_gp);

var _inp = get_player_input(pid);
var _key_right  = _inp.right;
var _key_left   = _inp.left;
var _key_jump   = _inp.jump;
var _key_attack = _inp.attack;

// INPUT DE DEFESA 
var _defend_btn = (_hasgp && gamepad_button_check(_gp, gp_shoulderr)) 
               || keyboard_check(ord("Q")); 

// Lógica de transição para defesa
if (_defend_btn && (state == PLAYER_STATE.FREE)) {
    state = PLAYER_STATE.DEFEND;
    image_index = 0;
}

// Lógica para sair da defesa quando soltar o botão
if (state == PLAYER_STATE.DEFEND && !_defend_btn) {
    state = PLAYER_STATE.FREE;
}
var _gp = (pid == 1) ? global.p1_gamepad : global.p2_gamepad;
var _hasgp = (_gp != noone) && gamepad_is_connected(_gp);

var _l2 = (_hasgp && gamepad_button_check(_gp, gp_shoulderl))
          || (pid == 1 && keyboard_check(ord("G")))
          || (pid == 2 && keyboard_check(ord("P")));

// Define se o menuta aberto 
special_menu_open = _l2 && (state == PLAYER_STATE.FREE || state == PLAYER_STATE.JUMP);

//EXECUTANDO OS ESPECIAIS 
if (special_menu_open && array_length(specials) > 0) {
    for (var _i = 0; _i < array_length(specials); _i++) {
        var _sp = specials[_i];
        
        // Verifica o botão correspondente do controle
        var _btn = _hasgp && gamepad_button_check_pressed(_gp, _sp.button);
        
        if (pid == 1) _btn = _btn || keyboard_check_pressed(_sp.key_alt);
        if (pid == 2) _btn = _btn || keyboard_check_pressed(_sp.key_alt);

        if (_btn) {
            if (special_points >= _sp.cost) {
                // Desconta as barras
                special_points -= _sp.cost;
                
                // Atribui o novo estado 
                state = _sp.state;
                
                image_index = 0;
                image_speed = 1;
                attack_hit_registered = false;
                special_menu_open = false; 
            } else {
                show_debug_message("DEBUG: Barras insuficientes para " + _sp.name);
            }
            break; 
        }
    }
}

//SISTEMA DE ULTIMATE 
if (meu_estado_ultimate != -1) {
    
    var _pode_usar_ultimate = (hp <= hp_max * 0.25) && !ultimate_used;
    var _lt = _hasgp && gamepad_button_check(_gp, gp_shoulderlb);
    var _rt = _hasgp && gamepad_button_check(_gp, gp_shoulderrb);

    var _teclado_ult = (pid == 1 && keyboard_check_pressed(ord("U"))) 
                    || (pid == 2 && keyboard_check_pressed(ord("I")));

    if (_pode_usar_ultimate && ((_lt && _rt) || _teclado_ult)) {
        if (state == PLAYER_STATE.FREE || state == PLAYER_STATE.JUMP) {
            
            ultimate_used = true; // Marca como gasta
            
            state = meu_estado_ultimate; 
            
            image_index = 0;
            image_speed = 1;
            attack_hit_registered = false;
            hspd = 0;
            vspd = 0;
        }
    }
}

if (variable_global_exists("ts_active") && global.ts_active && id == global.za_warudo_caster) {
    var _segurando_ataque = (_hasgp && gamepad_button_check(_gp, gp_face3)) || keyboard_check(ord("J"));
    
    if (_segurando_ataque) {
        if (state == PLAYER_STATE.FREE || state == "dio_barrage") {
            state = "dio_barrage";
        }
    } else {
        if (state == "dio_barrage") {
            state = PLAYER_STATE.FREE;
            if (audio_is_playing(Barrage)) audio_stop_sound(Barrage);
        }
    }
}
if (instance_exists(opponent)) {
   
    if (state == PLAYER_STATE.FREE || state == PLAYER_STATE.JUMP || state == PLAYER_STATE.DEFEND) {
        
        var _dir_to_opp = sign(opponent.x - x);
        
        // Garante que não mude se os dois estiverem no exato mesmo pixel (0)
        if (_dir_to_opp != 0) {
            facing = _dir_to_opp;
            image_xscale = facing;
        }
    }
}

// STATE MACHINE
switch (state) {

   case PLAYER_STATE.FREE:
        var _dir = _key_right - _key_left;
        hspd = _dir * walk_spd;

        sprite_index = (_dir != 0) ? char_sprites.walk : char_sprites.idle;

        if (place_meeting(x, y + 1, obj_wall) && _key_jump) {
            vspd  = jump_spd;
            state = PLAYER_STATE.JUMP;
            image_index = 0;
        }

        if (_key_attack) {
            state      = PLAYER_STATE.ATTACK_1;
            combo_next = false;
            image_index = 0;
            
            attack_hit_registered = false; 
            
            attack_sound_played = false; 
        }

        if (!place_meeting(x, y + 1, obj_wall)) {
            state = PLAYER_STATE.JUMP;
        }
    break;

    case PLAYER_STATE.JUMP:
        var _dir = _key_right - _key_left;
        hspd = _dir * walk_spd;

        sprite_index = (vspd < 0) ? char_sprites.jump : char_sprites.fall;

        if (place_meeting(x, y + 1, obj_wall)) {
            state = PLAYER_STATE.FREE;
            hspd  = 0;
        }
    break;

	case PLAYER_STATE.ATTACK_1:
	    hspd         = 0;
	    sprite_index = char_sprites.attack_1;
	    apply_attack_hit(attack_data.attack_1);

	    if (_key_attack) {
	        combo_next = true;
	    }
        
	    if (image_index >= image_number - 1) {
	        attack_hit_registered = false;
	        if (combo_next) {
	            state       = PLAYER_STATE.ATTACK_2;
	            combo_next  = false;
	            image_index = 0;
                attack_sound_played = false; 
	        } else {
	            state = PLAYER_STATE.FREE;
	        }
	    }
	break;

	case PLAYER_STATE.ATTACK_2:
	    hspd         = 0;
	    sprite_index = char_sprites.attack_2;
	    apply_attack_hit(attack_data.attack_2);

	    if (_key_attack) {
	        combo_next = true;
	    }
        
	    if (image_index >= image_number - 1) {
	        attack_hit_registered = false;
	        if (combo_next) {
	            state       = PLAYER_STATE.ATTACK_3;
	            combo_next  = false;
	            image_index = 0;
                attack_sound_played = false; // Permite o som do Combo 3
	        } else {
	            state = PLAYER_STATE.FREE;
	        }
	    }
	break;

	case PLAYER_STATE.ATTACK_3:
	    hspd         = 0;
	    sprite_index = char_sprites.attack_3;
	    apply_attack_hit(attack_data.attack_3);

	    if (image_index >= image_number - 1) {
	        attack_hit_registered = false;
	        state = PLAYER_STATE.FREE;
	    }
	break;

	case PLAYER_STATE.HIT:
        hspd = 0; 
        sprite_index = char_sprites.hit;
        
        // Congela a animação no último frame 
        if (image_index >= image_number - 1) {
            image_index = image_number - 1;
            image_speed = 0; // Trava a imagem
        }
        
        // Conta o tempo do Stun
        if (hit_stun_timer > 0) {
            hit_stun_timer--;
        } else {
            // Quando o timer zerar, ele se solta do combo
            if (hp <= 0) {
                state                  = PLAYER_STATE.KNOCKDOWN;
                knockdown_on_ground    = false;
                knockdown_ground_timer = 0;
                image_index            = 0;
                image_speed            = 1;
            } else {
                state = PLAYER_STATE.FREE;
                image_speed = 1; // Devolve a velocidade normal da animação
            }
        }
    break;

    case PLAYER_STATE.KNOCKDOWN:
        sprite_index = char_sprites.knockdown;
        
        
        if (!knockdown_on_ground) {
            if (floor(image_index) >= knockdown_fall_frames) {
                image_index = knockdown_fall_frames;
                image_speed = 0;
            }

            if (place_meeting(x, y + 1, obj_wall) && vspd >= 0) {
                knockdown_on_ground    = true;
                knockdown_ground_timer = 0;
                hspd        = 0;
                vspd        = 0;
                image_speed = 0;
            }
        } else {
            hspd = 0;
            knockdown_ground_timer++;
            if (knockdown_ground_timer >= knockdown_ground_delay) {
                image_speed = 1;
                if (floor(image_index) < knockdown_rise_frame) {
                    image_index = knockdown_rise_frame;
                }
                if (floor(image_index) >= image_number - 1) {
                    knockdown_on_ground    = false;
                    knockdown_ground_timer = 0;
                    state     = PLAYER_STATE.FREE;
                    inv_timer = inv_dur * 2;
                }
            }
        }
	break;
	
	case PLAYER_STATE.WIN:
	    sprite_index = char_sprites.win;
	    image_speed = 1;
    
	    // Lógica do Loop
	    if (win_loop_start != -1 && image_index >= win_loop_end) {
	        image_index = win_loop_start;
	    } 
	    else if (win_loop_start == -1 && image_index >= image_number - 1) {
	        image_index = image_number - 1;
	        image_speed = 0;
	    }
	break;

	case PLAYER_STATE.LOSE:
	    sprite_index = char_sprites.lose;
	    image_speed = 1;
	    // Trava no último frame
	    if (image_index >= image_number - 1) {
	        image_index = image_number - 1;
	        image_speed = 0;
	    }
	break;

	case PLAYER_STATE.DEAD:
        hspd         = 0;
        sprite_index = char_sprites.dead;
        if (image_index >= image_number - 1) image_speed = 0;
    break;
	
	case PLAYER_STATE.DEFEND:
        hspd = 0; 
        sprite_index = char_sprites.defend;
        image_speed = 1; 
        
    break;
	
}

if (is_numeric(state)) {
    if (state >= PLAYER_STATE.SPECIAL_START) {
        show_debug_message("DEBUG: Estado " + string(state) + " é válido. Chamando handle_specials().");
        handle_specials();
    } else {

        show_debug_message("DEBUG: Estado " + string(state) + " é NUMÉRICO mas menor que 100.");
    }
} else {
    show_debug_message("DEBUG: O estado ATUAL é um TEXTO ('" + string(state) + "'), por isso o handle_specials foi ignorado.");
}

// SISTEMA DE COLISÃO ENTRE PLAYERS 
if (instance_exists(opponent) && state != PLAYER_STATE.DEAD) {
    if (hspd != 0 && place_meeting(x + hspd, y, opponent)) {
        if (bbox_bottom > opponent.bbox_top) {
            var _dir_to_opp = sign(opponent.x - x);
            var _dir_mov    = sign(hspd);
            
            if (_dir_mov == _dir_to_opp) {
                while (!place_meeting(x + sign(hspd), y, opponent)) {
                    x += sign(hspd);
                }
                hspd = 0;
            }
        }
    }

    if (place_meeting(x, y, opponent)) {
        var _push = sign(x - opponent.x);
        if (_push == 0) {
            _push = (pid == 1) ? -1 : 1; 
        }
        if (!place_meeting(x + (_push * 3), y, obj_wall)) {
            x += _push * 3;
        }
    }
}
// handle_specials
if (is_numeric(state) && state >= PLAYER_STATE.SPECIAL_START) {
    handle_specials();
}


aplica_fisica_e_colisao();