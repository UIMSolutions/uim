module uim.orm.classes.tables.table;

import uim.orm;
@safe:

class DORMTable : UIMObject, IORMTable {
    mixin(ORMTableThis!());

        // Name of default validation set.
    const string DEFAULT_VALIDATOR = "default";

    // The alias this object is assigned to validators as.
    const string VALIDATOR_PROVIDER_NAME = "table";

    // The name of the event dispatched when a validator has been built.
    const string BUILD_VALIDATOR_EVENT = "Model.buildValidator";


    // Name of the table as it can be found in the database
    protected string _tableName = null;

    /**
     * Human name giving to this particular instance. Multiple objects representing
     * the same database table can exist by using different aliases.
     */
    protected string _aliasName = null;

    // The name of the field that represents the primary key in the table
    protected string[] _primaryKeys = null;

    // The name of the field that represents a human-readable representation of a row
    protected string[] _displayFields = null;

    // The name of the class that represent a single row for this table
    protected string _entityClass = null;

    // Registry key used to create this table object
    protected string _registryAlias = null;
}