module uim.commands.interfaces.command;

import uim.commands;

@safe:

interface ICommand : INamed {
    abstract int execute(Json[string] arguments, IConsole console = new);
}