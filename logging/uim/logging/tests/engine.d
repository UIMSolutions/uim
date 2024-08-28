module uim.logging.tests.engine;

import uim.logging;
@safe:

bool testLogEngine(ILogEngine logEngineToTest) {
    assert(logEngineToTest !is null, "In testLogEngine: logEngineToTest is null");
    
    return true;
}