module uim.oop.mixins.registry;

import uim.oop;

@safe:

template TRegistry(T : UIMObject, R, M) {
    R registry;

    size_t length() {
        return registry.length;
    }

    T[] objects() {
        return registry.objects;
    }

    T get(string key) {
        return registry.get(key, null);
    }

    M set(string key, IController newController) {
        registry.set(key, newController);
        return cast(M)this;
    }

}