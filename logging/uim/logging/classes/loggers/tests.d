module uim.oop.logging.loggers.tests;

import uim.oop;

@safe:

bool testLogger(ILogger loggerToTest) {
    assert(loggerToTest !is null, "In testLogger: loggerToTest is null");
    
    return true;
}