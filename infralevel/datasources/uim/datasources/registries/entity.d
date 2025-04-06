module uim.datasources.registries.entity;

mixin(Version!"test_uim_datasources");

import uim.datasources;
@safe:

// A registry object for Entity instances.
class DDatasourceEntityRegistry : DObjectRegistry!DDatasourceEntity {
}
auto DataSourceEntityRegistry() { return DDatasourceEntityRegistry.registration; }


    