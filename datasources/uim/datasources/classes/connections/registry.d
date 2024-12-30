module uim.datasources.classes.connections.registry;

import uim.datasources;

@safe:

// A registry object for connection instances.
class DDatasourceConnectionRegistry : DObjectRegistry!DDatasourceConnection {
}

auto DatasourceConnectionRegistration() { // SIngleton
    return DDatasourceConnectionRegistry.registration;
}
