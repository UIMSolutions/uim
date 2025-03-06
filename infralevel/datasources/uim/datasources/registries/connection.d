module uim.datasources.registries.connection;

import uim.datasources;

@safe:

// A registry object for connection instances.
class DDatasourceConnectionRegistry : DObjectRegistry!DDatasourceConnection {
}

auto DatasourceConnectionRegistry() { // Singleton
    return DDatasourceConnectionRegistry.registration;
}
