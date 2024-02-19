module uim.consoles.interfaces.command;

import uim.consoles;

@safe:

// Describe the interface between a command and the surrounding console libraries.
interface ICommand {
    // Default error code
    const int CODE_ERROR = 1;

    // Default success code
    const int CODE_SUCCESS = 0;

    // Set the name this command uses in the collection.
    void name(string commandName);

    // Run the command.
    int run(IData[string] cliArguments, ConsoleIo consoleIo);
}