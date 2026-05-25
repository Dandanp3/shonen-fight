var _p1 = noone;
var _p2 = noone;

// Varre a sala procurando as instâncias genéricas pelos PIDs configurados
with (oPlayer) {
    if (pid == 1) _p1 = id;
    if (pid == 2) _p2 = id;
}

// Se algum sumiu ou não carregou, aborta para evitar crash
if (!instance_exists(_p1) || !instance_exists(_p2)) exit;

// Linka um como oponente do outro de forma dinâmica
_p1.opponent = _p2;
_p2.opponent = _p1;

// Configura o direcionamento inicial na tela
_p1.facing       =  1;
_p1.image_xscale =  1;
_p2.facing       = -1;  
_p2.image_xscale = -1;