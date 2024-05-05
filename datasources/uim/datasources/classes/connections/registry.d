module uim.datasources.classes.connections.registry;

import uim.datasources;

@safe:

// A registry object for connection instances.
class DConnectionRegistry : DObjectRegistry!DDatasourceConnection {
}
auto ConnectionRegistry() { return new DConnectionRegistry; }


    