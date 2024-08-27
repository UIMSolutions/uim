module uim.oop.logging.loggers.collection;

import uim.oop;
@safe:

class DLoggerCollection : DCollection!DLogger {   
}
auto LoggerCollection() { return new DLoggerCollection; }