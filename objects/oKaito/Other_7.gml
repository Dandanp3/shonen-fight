if (state == PLAYER_STATE.SPECIAL_START + 2) {
    state = PLAYER_STATE.FREE; // Destrava o jogador
    special_spawned = false;   // Reseta a variável para a próxima vez
    attack_hit_registered = false;
}