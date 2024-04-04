module uim.oop.errors.registry;

import uim.oop;

@safe:
class DErrorRegistry : DObjectRegistry!DError{
}
auto errorRegistry() { // Singleton
  return 
    DErrorRegistry.instance;
}

unittest {
// TODO   assert(ErrorRegistry.instance("mvc_exceptioncomponent",  Error).paths == ["mvc_exceptioncomponent"]);
// TODO   assert(ErrorRegistry.instance("mvc_exceptioncomponent2", Error).paths.length == 2);
}