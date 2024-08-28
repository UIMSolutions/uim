module uim.logging.engines.registry;

import uim.oop;

@safe:

class DLogEngineRegistry : DObjectRegistry!DLogEngine {
}

auto LogEngineRegistry() {
    return DLogEngineRegistry.registry;
}
