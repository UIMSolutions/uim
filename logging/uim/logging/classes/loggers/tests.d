module uim.logging.loggers.tests;

import uim.logging;

@safe:

bool testLogger(ILogger loggerToTest) {
    assert(loggerToTest !is null, "In testLogger: loggerToTest is null");
    
    return true;
}