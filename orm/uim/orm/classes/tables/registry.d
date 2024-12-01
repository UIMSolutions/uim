module uim.orm.classes.tables.registry;

import uim.orm;

@safe:

class DORMTableRegistry : DObjectRegistry!DORMTable {
}
auto ORMTableRegistry() { 
    return DORMTableRegistry.registry is null
        ? DORMTableRegistry.registry = new DORMTableRegistry
        : DORMTableRegistry.registry;
}