module uim.consoles.interfaces.commandfactory;

import uim.consoles;

@safe:

// An interface for abstracting creation of command and shell instances.
interface ICommandFactory {
    // The factory method for creating Command  instances.
    ICommand create(string commandClassName);
}
