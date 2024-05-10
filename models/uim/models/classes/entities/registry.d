module models.uim.models.classes.entities.registry;

import uim.models;

@safe:
class DEntityRegistry : DObjectRegistry!DEntity {
  static DEntityRegistry registry;
}
auto EntityRegistry() { // Singleton
  if (DEntityRegistry.instance.isNull) {
    DEntityRegistry.instance = new DEntityRegistry;
  }
  return DEntityRegistry.instance;
}
