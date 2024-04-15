module uim.consoles.tests.command;

import uim.consoles;

@safe:

bool testCommand(IConsoleCommand commandToTest) {
    assert(commandToTest !is null, "In testCommand: commandToTest is null");
    
    return true;
}