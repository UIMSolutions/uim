module uim.consoles.tests.console;

import uim.consoles;

@safe:

bool testConsole(IConsole consoleToTest) {
    assert(consoleToTest !is null, "In testConsole: consoleToTest is null");
    
    return true;
}