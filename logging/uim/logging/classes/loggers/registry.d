module uim.logging.loggers.registry;

import uim.logging;

@safe:

class DLoggerRegistry : DObjectRegistry!DLogger {
}
auto LoggerRegistry() { return DLoggerRegistry.registry; }
