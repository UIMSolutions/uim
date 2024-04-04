module uim.oop.exceptions.registry;

import uim.oop;

@safe:
class DExceptionRegistry : DObjectRegistry!UimException{
}
auto ExceptionRegistry() { // Singleton
  return 
    DExceptionRegistry.instance;
}

version(test_uim_mvc) { unittest {
  assert(ExceptionRegistry.instance("mvc_exceptioncomponent",  Exception).paths == ["mvc_exceptioncomponent"]);
  assert(ExceptionRegistry.instance("mvc_exceptioncomponent2", Exception).paths.length == 2);
}}