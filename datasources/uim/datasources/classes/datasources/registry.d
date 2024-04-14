module uim.datasources.classes.datasources.registry;

import uim.datasources;

@safe:

// A registry object for Datasource instances.
class DDatasourceRegistry : DObjectRegistry!IDatasource {
}
auto DatasourceRegistry() { return DDatasourceRegistry.instance; }


    