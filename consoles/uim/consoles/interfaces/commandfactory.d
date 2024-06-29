module uim.consoles.interfaces.commandfactory;

import uim.consoles;

@safe:

// An interface for abstracting creation of command and shell instances.
interface IConsoleCommandFactory {
    // The factory method for creating Command  instances.
    IConsoleCommand create(string commandclassname);
}
