module uim.consoles.tests.console;

import uim.commands;

@safe:

bool testCommand(ICommand commandToTest) {
    assert(!commandToTest.isNull, "In testCommand: commandToTest is null");
    
    return true;
}