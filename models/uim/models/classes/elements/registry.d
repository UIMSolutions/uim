module uim.models.classes.elements.registry;

import uim.models;

@safe:
class DElementRegistry : DRegistry!DElement {
  static DElementRegistry registry;
}
auto ElementRegistry() { // SIngleton
  if (DElementRegistry.registry is null) {
    DElementRegistry.registry = new DElementRegistry;
  }
  return DElementRegistry.registry;
}
