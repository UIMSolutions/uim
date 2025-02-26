module uim.datasources.registries.entity;

import uim.datasources;
@safe:

version (test_uim_datasources) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// A registry object for Entity instances.
class DDatasourceEntityRegistry : DObjectRegistry!DDatasourceEntity {
}
auto DataSourceEntityRegistry() { return DDatasourceEntityRegistry.registration; }


    