module uim.oop.exceptions.registry;

import uim.oop;

@safe:
class DExceptionRegistry : ObjectRegistry!UimException{
  static DExceptionRegistry registry; 
}
auto ExceptionRegistry() { // Singleton
  if (!DExceptionRegistry.registry) {
    DExceptionRegistry.registry = new DExceptionRegistry; 
  }
  return 
    DExceptionRegistry.registry;
}

version(test_uim_mvc) { unittest {
  assert(ExceptionRegistry.register("mvc_exceptioncomponent",  Exception).paths == ["mvc_exceptioncomponent"]);
  assert(ExceptionRegistry.register("mvc_exceptioncomponent2", Exception).paths.length == 2);
}}