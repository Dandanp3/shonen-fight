randomize(); // Garante aleatoriedade pura a cada partida

// 1. Sorteia quem vai ser o Objeto do Player 1 e do Player 2
var _p1_obj = choose(oKaito, oAizen);
var _p2_obj = (_p1_obj == oKaito) ? oAizen : oKaito; // O P2 pega o que sobrou

// 2. Spawna eles nos cantos da tela
var _p1 = instance_create_layer(320, 540, "Instances", _p1_obj); 
var _p2 = instance_create_layer(960, 540, "Instances", _p2_obj);

// 3. Carimba o passaporte de controle deles
_p1.pid = 1; // Vai responder aos botões/controles do Player 1 no seu script
_p2.pid = 2; // Vai responder aos botões/controles do Player 2 no seu script

// 4. Ativa o alarme no frame seguinte para linkar os oponentes (mira dinâmica)
alarm[0] = 1;