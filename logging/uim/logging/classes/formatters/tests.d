module uim.logging.formatters.tests;

import uim.oop;

@safe:

bool testLogFormatter(ILogFormatter logFormatterToTest) {
    assert(logFormatterToTest !is null, "In testLogFormatter: logFormatterToTest is null");
    
    return true;
}