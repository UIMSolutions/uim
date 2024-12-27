module uim.caches.classes.engines.engine;

import uim.caches;

@safe:

// Storage engine for UIM caching
class DCacheEngine : UIMObject, ICacheEngine {
    mixin(CacheEngineThis!());
}
