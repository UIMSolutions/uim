module uim.caches.helpers.engine;

import uim.caches;

bool isEngine(Object instance) {
    if (cast(ICacheEngine)instance) {
        return true;
    }

    return false;
}