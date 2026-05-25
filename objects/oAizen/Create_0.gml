// 1. Puxa as variáveis do pai
event_inherited(); 

// 2. Atribui os sprites normais
char_sprites.idle      = sAizenIdle;
char_sprites.walk      = sAizenWalk;
char_sprites.jump      = sAizenJump;
char_sprites.fall      = sAizenFall;
char_sprites.attack_1  = sAizenCombo1;
char_sprites.attack_2  = sAizenCombo2;
char_sprites.attack_3  = sAizenCombo3;
char_sprites.hit       = sAizenHit;
char_sprites.knockdown = sAizenKnockown;
char_sprites.defend    = sAizenDefend;

// 3. Registra o Kurohitsugi no menu
array_push(specials, {
    name: "Kurohitsugi",       
    cost: 2,                   
    button: gp_face3,          
    button_label: "X",         
    key_alt: ord("J"),         
    state: PLAYER_STATE.SPECIAL_START + 1 
});

// 4. Lógica de execução do estado 101
handle_specials = function() {
    if (state == PLAYER_STATE.SPECIAL_START + 1) {
        
        // Executa apenas no primeiro frame da animação
        // ATENÇÃO: Substitua 'sAizenSpecial' pelo nome do seu sprite do Aizen conjurando!
        if (floor(image_index) == 0 && sprite_index != Hadou) {
            sprite_index = Hadou; 
            image_speed = 1;
            hspd = 0; 
            vspd = 0;
            
            // Spawna o Hadou no pé do oponente
            if (instance_exists(opponent)) {
                var _hadou = instance_create_layer(opponent.x, opponent.y, "Instances", oHadou);
                _hadou.target = opponent;
                _hadou.dmg = 35;
                _hadou.facing = facing;
            }
        }
    }
};