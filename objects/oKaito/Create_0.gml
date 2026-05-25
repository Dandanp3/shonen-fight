event_inherited();

char_sprites.idle      = sKaitoStand;
char_sprites.walk      = sKaitoWalk;
char_sprites.jump      = sKaitoJump;
char_sprites.fall      = sKaitoFall;
char_sprites.attack_1  = sKaitoCombo1;
char_sprites.attack_2  = sKaitoCombo2;
char_sprites.attack_3  = sKaitoCombo3;
char_sprites.hit       = sKaitoHit;
char_sprites.knockdown = sKaitoKnockback;

sprite_index = char_sprites.idle;
massa        = 1;


knockdown_fall_frames  = 1;
knockdown_rise_frame   = 2;
knockdown_ground_delay = 3;


attack_data = {
    attack_1: { dmg: 8,  hb_x: 35, hb_y: -20, hb_w: 40, hb_h: 40, frame_start: 1, frame_end: 3, knockback: 0 },
    attack_2: { dmg: 12, hb_x: 40, hb_y: -25, hb_w: 45, hb_h: 40, frame_start: 4, frame_end: 6, knockback: 0 },
    attack_3: { dmg: 20, hb_x: 45, hb_y: -30, hb_w: 50, hb_h: 45, frame_start: 2, frame_end: 4, knockback: 6 },
};


// No final do Create do oKaito, logo após o event_inherited();

// 1. Variável de controle de timing
special_spawned = false;

// 2. Registra o Especial no Menu (Consome 2 barras, ativado com X / J)
array_push(specials, {
    name: "Cuts",       
    cost: 2,                   
    button: gp_face3,          
    button_label: "X",         
    key_alt: ord("J"),         
    state: PLAYER_STATE.SPECIAL_START + 2 // Estado 102 exclusivo do Kaito
});

// 3. Execução do Estado do Especial
handle_specials = function() {
    if (state == PLAYER_STATE.SPECIAL_START + 2) {
        
        // Inicialização: Roda apenas no primeiro frame do estado
        if (sprite_index != KaitoScythe) {
            sprite_index = KaitoScythe; 
            image_index = 0;
            image_speed = 1;
            hspd = 0; 
            vspd = 0;
            special_spawned = false; // Garante que o gatilho está pronto para disparar
        }
        
        // GATILHO DE TIMING: Logo após o frame 21 (ou seja, a partir do frame 22)
        if (floor(image_index) > 21 && !special_spawned) {
            special_spawned = true; // Trava o gatilho para spawnar apenas UM objeto
            
            // Spawna os cortes direto na posição atual do Aizen
            if (instance_exists(opponent)) {
                var _cuts = instance_create_layer(opponent.x, opponent.y, "Instances", oCuts);
                _cuts.target = opponent;
                _cuts.dmg = 40; // Defina o dano do especial do Kaito aqui
                _cuts.facing = facing;
            }
        }
    }
};