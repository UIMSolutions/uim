module uim.oop.logging.loggers.registry;

import uim.oop;

@safe:

class DLoggerRegistry : DObjectRegistry!DLogger {
}
auto LoggerRegistry() { return DLoggerRegistry.registry; }
