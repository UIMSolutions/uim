module uim.oop.mixins.registry;

import uim.oop;
@safe:

string mixinRegistry(string single, string plural) {
    return "
    protected D"~single~"Registry _"~single.toLower~"Registry;
    I"~single~"[] "~plural.toLower~"() {
        return _"~single.toLower~"Registry.objects.map!(c => cast(I"~single~")c).array;
    }

    I"~single~" "~single.toLower~"(string key) {
        return cast(I"~single~")_"~single.toLower~"Registry.get(key);
    }
    IApp "~single.toLower~"(string key, I"~single~" new"~single~") {
        _"~single.toLower~"Registry.register(key, cast(D"~single~")new"~single~");
        return this;
    }
    IApp remove"~single~"(string key) {
        _"~single.toLower~"Registry.removeKey(key);
        return this;
    }"; 
}
template MixinRegistry(string single, string plural) {
    const char[] MixinRegistry = mixinRegistry(single, plural);
}