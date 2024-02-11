module uim.models.classes.entities.registry;

import uim.models;

@safe:
class DEntityRegistry : DRegistry!DEntity {
  static DEntityRegistry registry;
}
auto EntityRegistry() { // SIngleton
  if (DEntityRegistry.registry is null) {
    DEntityRegistry.registry = new DEntityRegistry;
  }
  return DEntityRegistry.registry;
}
