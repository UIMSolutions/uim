module uim.core.helpers.map;

import uim.core;

@safe:

class Map {
    static V[K] create(K, V)() {
        return V[K]();
    }
}

unittest {
    auto map = Map.create!(string, string)();
}