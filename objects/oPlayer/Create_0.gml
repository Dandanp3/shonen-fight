inicia_fisica(1);
ts_damage_pool = 0;
hit_stun_timer = 0;
hit_stun_dur   = 60;
self.hspd  = 0; 
self.vspd  = 0;   
self.massa = 1; 
pid  = 0;     
opponent   = noone;  

// MOVIMENTO 
hspd = 0;
vspd = 0;
walk_spd = 3.5;
jump_spd = -8;

// VIDA E COMBATE 
hp_max          = 500;
hp              = hp_max; 
combo_next      = false;
knockdown_timer = 0;
knockdown_dur   = 1;
inv_timer       = 0;
inv_dur         = 40;

// BARRA DE ESPECIAL
special_energy     = 0;
special_energy_max = 180;
special_points     = 1;
special_points_max = 5;
ultimate_used = false;
meu_estado_ultimate = -1

add_special_energy = function(_amount) {
    special_energy += _amount;
    if (special_energy >= special_energy_max) {
        special_points += 1;
        special_energy -= special_energy_max; 
    }
}

facing       = 1;
image_xscale = facing;

char_sprites = {
    idle:      -1,
    walk:      -1,
    jump:      -1,
    fall:      -1,
    attack_1:  -1,
    attack_2:  -1,
    attack_3:  -1,
    hit:       -1,
    knockdown: -1,
    dead:      -1,
	win:       -1, 
    lose:      -1,
	defend: -1
};

enum PLAYER_STATE {
    FREE,
    JUMP,
    ATTACK_1,
    ATTACK_2,
    ATTACK_3,
    HIT,
    KNOCKDOWN,
    DEAD,
	WIN, 
	LOSE,
	DEFEND,
    SPECIAL_START = 100  
}

// DefiniçOes de VitOria 
win_loop_start = -1; 
win_loop_end   = -1;
state = PLAYER_STATE.FREE;
handle_specials = function() {  };

knockdown_fall_frames  = 5;
knockdown_rise_frame   = 6;
knockdown_ground_delay = 30;  
knockdown_on_ground    = false;
knockdown_ground_timer = 0;

// Configuração padrão de ataques 
attack_data = {
    attack_1: { dmg: 8,  hb_x: 35, hb_y: -20, hb_w: 40, hb_h: 40, frame_start: 3, frame_end: 5, knockback: 0 },
    attack_2: { dmg: 12, hb_x: 40, hb_y: -25, hb_w: 45, hb_h: 40, frame_start: 3, frame_end: 7, knockback: 0 },
    attack_3: { dmg: 20, hb_x: 45, hb_y: -30, hb_w: 50, hb_h: 45, frame_start: 1, frame_end: 6, knockback: 6 }, 
};
attack_hit_registered = false;
attack_sound_played   = false;

take_damage = function(dmg, knockback_dir, knockback_force, knockback_vspd) {
    if (state == PLAYER_STATE.DEAD || inv_timer > 0) exit;

    attack_hit_registered = false; 

    // DEFESA 
    var _final_dmg = dmg;
    if (state == PLAYER_STATE.DEFEND) {
        _final_dmg = ceil(dmg * 0.2); 
    }

    add_special_energy(_final_dmg * 2); 
    hp = max(0, hp - _final_dmg); 
    
    // Morte
    if (hp <= 0) {
        hspd = knockback_dir * max(4, knockback_force ?? 4);
        vspd = knockback_vspd ?? -7;
        state = PLAYER_STATE.KNOCKDOWN;
        knockdown_on_ground = false;
        inv_timer = inv_dur;
        exit;
    }

    var _force = knockback_force ?? 0;
    var _vspd  = knockback_vspd ?? -7;

    // Knockback vs Hit Normal
    if (_force > 0) {
        if (state == PLAYER_STATE.DEFEND) {
            hspd = knockback_dir * (_force / (massa * 3)); 
            vspd = 0; // Não voa para cima
        } else {
            hspd = knockback_dir * (_force / massa);
            vspd = _vspd;               
            state = PLAYER_STATE.KNOCKDOWN;
            knockdown_on_ground = false;
            knockdown_ground_timer = 0;
            inv_timer = inv_dur; 
        }
    } else {
        // Hit normal 
        if (state != PLAYER_STATE.DEFEND) {
            hspd = 0;
            state = PLAYER_STATE.HIT;
            inv_timer = 0; 
            hit_stun_timer = hit_stun_dur;
        }
    }
};

apply_attack_hit = function(_data) {
    if (attack_hit_registered) exit;
    if (floor(image_index) < _data.frame_start || floor(image_index) > _data.frame_end) exit;
    
    var _base_x = x;
    var _base_y = y;
    
    // Calcula a Hitbox baseada na origem do Player (sem o Stand)
    var _hx = _base_x + (_data.hb_x * facing);
    var _hy = _base_y + _data.hb_y;
    
    var _hit = collision_rectangle(
        _hx - _data.hb_w * 0.5, _hy - _data.hb_h * 0.5,
        _hx + _data.hb_w * 0.5, _hy + _data.hb_h * 0.5,
        oPlayer, false, true
    );
    
    if (floor(image_index) == _data.frame_start && !attack_sound_played) {
        attack_sound_played = true; 
        
        if (_hit != noone) {
            audio_play_sound(damagePunch, 1, false); 
        } else {
            audio_play_sound(punch, 1, false); 
        }
    }
    
    // APLICAÇÃO REAL DO DANO E IMPACTO
    if (_hit != noone) {
        attack_hit_registered = true;
        _hit.take_damage(_data.dmg, facing, _data.knockback, -7);
        
        add_special_energy(_data.dmg);
        
        instance_create_layer(_hx, _hy, "Instances", oDamage);
        
        if (floor(image_index) > _data.frame_start) {
            audio_play_sound(damagePunch, 1, false);
        }
    }
};
specials          = [];
special_menu_open = false;
special_sound_id  = noone;