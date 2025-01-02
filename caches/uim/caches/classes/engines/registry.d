/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.caches.classes.engines.registry;

import uim.caches;

@safe:

// An object registry for cache engines.
class DCacheEngineRegistry : DObjectRegistry!DCacheEngine {
}

auto CacheEngineRegistration() { // Singleton
  return DCacheEngineRegistry.registration;
}
