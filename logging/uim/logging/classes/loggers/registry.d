module uim.logging.classes.loggers.registry;

import uim.logging;

@safe:

class DLoggerRegistry : DObjectRegistry!DLogger {
}
auto LoggerRegistry() { return DLoggerRegistry.registry; }
