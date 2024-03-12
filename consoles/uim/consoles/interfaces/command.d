module uim.consoles.interfaces.command;

import uim.consoles;

@safe:

// Describe the interface between a command and the surrounding console libraries.
interface IConsoleCommand {
    // Get & Set the name this command uses in the collection.
    string name();
    void name(string commandName);

    // Run the command.
    // TODO int run(IData[string] cliArguments, ConsoleIo consoleIo);
}