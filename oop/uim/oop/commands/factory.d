module uim.oop.commands.factory;

import uim.oop;

@safe:

class DCommandFactory : DFactory!DCommand {
}
auto CommandFactory() { return DCommandFactory.factory; }
