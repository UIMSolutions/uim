module uim.datasources.classes.entities.registry;

import uim.datasources;

@safe:

// A registry object for Entity instances.
class DEntityRegistry : DObjectRegistry!IDatasourceEntity {
}
auto EntityRegistry() { return DEntityRegistry.instance; }


    