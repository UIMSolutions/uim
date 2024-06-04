module uim.caches.classes.caches.registry;

import uim.caches;

@safe:

// An object registry for cache engines.
class DCacheRegistry : DObjectRegistry!DCache {
}
auto CacheRegistry() { // Singleton
  return DCacheRegistry.registry;
}
