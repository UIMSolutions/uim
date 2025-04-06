module uim.datasources.registries.connection;

mixin(Version!"test_uim_datasources");

import uim.datasources;
@safe:

// A registry object for connection instances.
class DDatasourceConnectionRegistry : DObjectRegistry!DDatasourceConnection {
}

auto DatasourceConnectionRegistry() { // Singleton
    return DDatasourceConnectionRegistry.registration;
}
