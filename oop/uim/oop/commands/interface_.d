module uim.oop.commands.interface_;

import uim.oop;
@safe:

interface ICommand :INamed {
    int execute(Json[string] options, IConsole console = null);
}