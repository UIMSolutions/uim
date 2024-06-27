module uim.oop.commands.registry;

import uim.oop;
@safe:

class DCommandRegistry : DObjectRegistry!DCommand {
}
auto CommandRegistry() { return DCommandRegistry.registry; }