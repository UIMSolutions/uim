module uim.consoles.interfaces.command;

import uim.consoles;

@safe:

// Describe the interface between a command and the surrounding console libraries.
interface IConsoleCommand : INamed {
    // Run the command.
    // TODO int run(Json[string] cliArguments, ConsoleIo consoleIo);
}