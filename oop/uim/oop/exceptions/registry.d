module uim.oop.exceptions.registry;

import uim.oop;

@safe:
class UimExceptionRegistry : DRegistry!UimException{
  this() {}

  static UimExceptionRegistry registry; 
}
auto ExceptionRegistry() { // Singleton
  if (!UimExceptionRegistry.registry) {
    UimExceptionRegistry.registry = new UimExceptionRegistry; 
  }
  return 
    UimExceptionRegistry.registry;
}

version(test_uim_mvc) { unittest {
  assert(ExceptionRegistry.register("mvc_exceptioncomponent",  Exception).paths == ["mvc_exceptioncomponent"]);
  assert(ExceptionRegistry.register("mvc_exceptioncomponent2", Exception).paths.length == 2);
}}