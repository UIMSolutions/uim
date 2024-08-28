module uim.logging.classes.loggers.factory;

import uim.logging;
@safe:

class DLoggerFactory : DFactory!DLogger {}
auto LoggerFactory() { return DLoggerFactory.factory; }