module uim.logging.classes.loggers.registry;

import uim.logging;

@safe:

// Registry of loaded log engines
class DLogEngineRegistry : DObjectRegistry!DLogEngine {
}

auto LogEngineRegistry() {
    return DLogEngineRegistry.instance;
}

