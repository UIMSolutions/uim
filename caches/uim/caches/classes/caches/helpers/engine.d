module source.uim.caches.helpers.engine;

import uim.caches;

bool isEngine(Object instance) {
    if (cast(IEngine)instance) {
        return true;
    }

    return false;
}