module uim.consoles.tests.console;

import uim.consoles;

@safe:

bool testConsole(IConsole consoleToTest) {
    assert(!consoleToTest.isNull, "In testConsole: consoleToTest is null");
    
    return true;
}