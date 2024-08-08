module uim.oop.commands.interfaces;

import uim.oop;
@safe:

interface ICommand : INamed {
    ulong execute(Json[string] options, IConsole console = null);
}