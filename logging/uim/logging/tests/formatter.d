module uim.logging.tests.formatter;

import uim.logging;

@safe:

bool testCommand(ICommand commandToTest) {
    assert(!commandToTest.isNull, "In testCommand: commandToTest is null");
    
    return true;
}