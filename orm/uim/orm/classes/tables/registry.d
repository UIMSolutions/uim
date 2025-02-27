module uim.orm.classes.tables.registration;

import uim.orm;

@safe:

// Provides a registry/factory for Table objects.
class DORMTableRegistry : DObjectRegistry!DORMTable {
}
auto ORMTableRegistry() { 
    return DORMTableRegistry.registration;
}