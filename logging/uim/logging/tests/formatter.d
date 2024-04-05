module uim.logging.tests.formatter;

import uim.logging;

@safe:

bool testLogFormatter(ILogFormatter logFormatterToTest) {
    assert(logFormatterToTest !is null, "In testLogFormatter: logFormatterToTest is null");
    
    return true;
}