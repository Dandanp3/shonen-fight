if (floor(image_index) == 2 && !has_hit) {
    has_hit = true;
    
    if (instance_exists(target)) {
        target.take_damage(dmg, facing, 6, -8); 
        
        instance_create_layer(x, y, "Instances", oDamage);
    }
}