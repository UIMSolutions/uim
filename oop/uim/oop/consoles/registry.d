module uim.oop.consoles.registry;

import uim.oop;
@safe:

class DConsoleRegistry : DObjectRegistry!DConsole {
}
auto ConsoleRegistry() { return DConsoleRegistry.registry; }