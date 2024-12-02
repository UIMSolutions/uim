module uim.datasources.classes.entities.registry;

import uim.datasources;

@safe:

// A registry object for Entity instances.
class DDatasourceEntityRegistry : DObjectRegistry!DDatasourceEntity {
}
auto DataSourceEntityRegistry() { return DDatasourceEntityRegistry.registry; }


    