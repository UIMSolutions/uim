module uim.oop.exceptions.registry;

import uim.oop;

@safe:
class DExceptionRegistry : DObjectRegistry!UimException {
      this() {}
}
auto ExceptionRegistry() { // Singleton
  return 
    DExceptionRegistry.instance;
}

unittest {
  // TODO assert(ExceptionRegistry.instance("mvc_exceptioncomponent",  Exception).paths == ["mvc_exceptioncomponent"]);
  // TODO assert(ExceptionRegistry.instance("mvc_exceptioncomponent2", Exception).paths.length == 2);
}