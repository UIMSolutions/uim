module caches.uim.caches.helpers.cache;

import uim.caches;

bool isCache(Object instance) {
    if (cast(ICache)instance) {
        return true;
    }

    return false;
}