module oop.uim.oop.consoles copy.registry;

import uim.oop;
@safe:

class DConsoleRegistry : DObjectRegistry!DConsole {
}
auto ConsoleRegistry() { return DConsoleRegistry.registry; }