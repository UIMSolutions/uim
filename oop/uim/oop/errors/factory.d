module uim.oop.errors.factory;

import uim.oop;

@safe:

class DErrorFactory : DFactory!DError {
}
auto ConsoleFactory() { return DConsoleFactory.factory; }
