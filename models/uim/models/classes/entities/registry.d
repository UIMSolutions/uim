module uim.models.classes.entities.registry;

import uim.models;

@safe:
class DEntityRegistry : DObjectRegistry!DEntity {
}
auto EntityRegistry() { // Singleton
  return DEntityRegistry.registry;
}
