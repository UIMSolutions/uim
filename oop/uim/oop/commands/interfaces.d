module uim.oop.commands.interfaces;

import uim.oop;
@safe:

interface ICommand :INamed {
    int execute(Json[string] options, IConsole console = null);
}