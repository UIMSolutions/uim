module uim.datasources.registries.datasource;

mixin(Version!"test_uim_datasources");

import uim.datasources;
@safe:

version (test_uim_datasources) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

// A registry object for Datasource instances.
class DDatasourceRegistry : DObjectRegistry!DDatasource {
}

auto DatasourceRegistration() {
    return DDatasourceRegistry.registration;
}
