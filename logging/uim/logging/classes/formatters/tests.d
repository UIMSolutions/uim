module uim.logging.formatters.tests;

import uim.logging;

@safe:

bool testLogFormatter(ILogFormatter logFormatterToTest) {
    assert(logFormatterToTest !is null, "In testLogFormatter: logFormatterToTest is null");
    
    return true;
}