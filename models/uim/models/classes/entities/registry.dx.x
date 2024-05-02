module uim.models.classes.entities.registry;

import uim.models;

@safe:
class DEntityRegistry : DObjectRegistry!DEntity {
  static DEntityRegistry registry;
}
auto EntityRegistry() { // SIngleton
  if (DEntityRegistry.instance is null) {
    DEntityRegistry.instance = new DEntityRegistry;
  }
  return DEntityRegistry.instance;
}
