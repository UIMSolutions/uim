module uim.logging.classes.loggers.collection;

import uim.logging;
@safe:

class DLoggerCollection : DCollection!DLogger {   
}
auto LoggerCollection() { return new DLoggerCollection; }