module uim.oop.logging.loggers.factory;

import uim.oop;
@safe:

class DLoggerFactory : DFactory!DLogger {}
auto LoggerFactory() { return DLoggerFactory.factory; }