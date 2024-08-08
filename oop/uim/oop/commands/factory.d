module uim.oop.commands.factory;

import uim.oop;

@safe:

class DUIMCommandFactory : DFactory!DCommand {
}
auto CommandFactory() { return DUIMCommandFactory.factory; }
