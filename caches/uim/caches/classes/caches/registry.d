module uim.caches.classes.caches.registry;

import uim.caches;

@safe:

// An object registry for cache engines.
class DCacheRegistry : DObjectRegistry!DCache {
  this() {}
}
auto CacheRegistry() { // Singleton
  return DCacheRegistry.instance;
}
