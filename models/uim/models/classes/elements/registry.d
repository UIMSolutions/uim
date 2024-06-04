module uim.models.classes.elements.registry;

import uim.models;

@safe:
class DElementRegistry : DObjectRegistry!DElement {
}
auto ElementRegistry() { // Singleton
  return DElementRegistry.registry;
}
