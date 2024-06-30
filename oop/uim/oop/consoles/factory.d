module uim.oop.consoles.factory;

import uim.oop;
@safe:

class DConsoleFactory : DFactory!DConsole {}
auto ConsoleFactory() { return DConsoleFactory.factory; }
