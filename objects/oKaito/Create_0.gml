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


rr_phase         = 0;
rr_timer         = 0;
rr_impact_shaked = false;

specials = [
    
];


is_attacking      = false;
is_attacking_held = false;