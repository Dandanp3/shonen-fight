// Troque o 2 pelo frame de impacto visual do seu sprite de corte
if (floor(image_index) == 2 && !has_hit) {
    has_hit = true;
    
    if (instance_exists(target)) {
        // Aplica o dano puxando a função que você estruturou no oPlayer
        // Parâmetros: (dano, direção, knockback_horizontal, knockback_vertical)
        target.take_damage(dmg, facing, 5, -6); 
        
        // Spawna o efeito visual de faísca/impacto opcional
        instance_create_layer(x, y, "Instances", oDamage);
    }
}