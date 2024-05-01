module uim.datasources.classes.datasources.registry;

import uim.datasources;

@safe:

// A registry object for Datasource instances.
class DDatasourceRegistry : DObjectRegistry!DDatasource {
}

auto DatasourceRegistry() {
    return DDatasourceRegistry.instance;
}
