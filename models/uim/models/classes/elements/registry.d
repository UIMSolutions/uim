module models.uim.models.classes.elements.registry;

import uim.models;

@safe:
class DElementRegistry : DObjectRegistry!DElement {
  static DElementRegistry registry;
}
auto ElementRegistry() { // Singleton
  if (DElementRegistry.instance.isNull) {
    DElementRegistry.instance = new DElementRegistry;
  }
  return DElementRegistry.instance;
}
