module uim.logging.classes.engines.registry;

import uim.logging;

@safe:

class DLogEngineRegistry : DObjectRegistry!DLogEngine {
}

auto LogEngineRegistry() {
    return DLogEngineRegistry.registry;
}
