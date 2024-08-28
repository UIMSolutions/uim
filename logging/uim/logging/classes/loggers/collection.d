module uim.logging.loggers.collection;

import uim.logging;
@safe:

class DLoggerCollection : DCollection!DLogger {   
}
auto LoggerCollection() { return new DLoggerCollection; }