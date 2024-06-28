module uim.oop.errors.registry;

import uim.oop;
@safe:

class DErrorRegistry : DObjectRegistry!DError {
}
auto ErrorRegistry() { return DErrorRegistry.registry; }