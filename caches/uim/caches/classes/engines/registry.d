module uim.caches.classes.engines.registry;

import uim.caches;

@safe:

// An object registry for cache engines.
class DCacheEngineRegistry : DObjectRegistry!DCacheEngine {
}
auto CacheEngineRegistry() { // Singleton
  return DCacheEngineRegistry.registry;
}
