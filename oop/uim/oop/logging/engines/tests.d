module uim.oop.logging.engines.tests;

import uim.oop;

@safe:

bool testLogEngine(ILogEngine logEngineToTest) {
    assert(logEngineToTest !is null, "In testLogEngine: logEngineToTest is null");
    
    return true;
}