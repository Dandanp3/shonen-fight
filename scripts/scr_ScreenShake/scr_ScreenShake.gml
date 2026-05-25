function screen_shake(_forca, _tempo) {
    var _shaker = instance_exists(oScreenShake)
                  ? oScreenShake
                  : instance_create_layer(0, 0, "Instances", oScreenShake);

    if (_forca >= _shaker.shake_power || _tempo > _shaker.shake_time) {
        _shaker.shake_power = _forca;
        _shaker.shake_time  = _tempo;
    }
}