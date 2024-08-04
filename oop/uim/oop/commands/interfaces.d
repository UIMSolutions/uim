module uim.oop.commands.interfaces;

import uim.oop;
@safe:

interface ICommand :INamed {
    size_t execute(Json[string] options, IConsole console = null);
}