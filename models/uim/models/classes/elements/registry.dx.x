module uim.models.classes.elements.registry;

import uim.models;

@safe:
class DElementRegistry : DObjectRegistry!DElement {
  static DElementRegistry registry;
}
auto ElementRegistry() { // SIngleton
  if (DElementRegistry.instance is null) {
    DElementRegistry.instance = new DElementRegistry;
  }
  return DElementRegistry.instance;
}
