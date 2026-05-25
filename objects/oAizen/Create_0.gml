// 1. PUXA TODAS AS VARIÁVEIS DO PAI (oPlayer)
event_inherited(); 

// 2. ATRIBUI OS SPRITES ESPECÍFICOS DO AIZEN
char_sprites.idle      = sAizenIdle;
char_sprites.walk      = sAizenWalk;
char_sprites.jump      = sAizenJump;
char_sprites.fall      = sAizenFall;
char_sprites.attack_1  = sAizenCombo1;
char_sprites.attack_2  = sAizenCombo2;
char_sprites.attack_3  = sAizenCombo3;
char_sprites.hit       = sAizenHit;
char_sprites.knockdown = sAizenKnockown;
//char_sprites.win       = sAizen_Win;
//char_sprites.lose      = sAizen_Lose;
char_sprites.defend    = sAizenDefend;