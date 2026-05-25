if (state == PLAYER_STATE.SPECIAL_START + 1) {
    state = PLAYER_STATE.FREE; // Devolve o controle ao jogador!
    attack_hit_registered = false;
}