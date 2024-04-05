module uim.commands.tests.command;

import uim.commands;

@safe:

bool testCommand(ICommand commandToTest) {
    assert(!commandToTest.isNull, "In testCommand: commandToTest is null");
    
    return true;
}