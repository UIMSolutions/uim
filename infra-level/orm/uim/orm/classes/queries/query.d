module uim.orm.classes.queries.query;

import uim.orm;
@safe:

class DORMQuery : UIMObject, IORMQuery {
    mixin(ORMQueryThis!());
    // Indicates that the operation should append to the list
    const int APPEND = 0;

    // Indicates that the operation should prepend to the list
    const int PREPEND = 1;

    // Indicates that the operation should overwrite the list
    const bool OVERWRITE = true;

    /**
     * Whether the user select any fields before being executed, this is used
     * to determined if any fields should be automatically be selected.
     */
    protected bool _hasFields;

    /**
     * Tracks whether the original query should include
     * fields from the top level table.
     */
    protected bool _autoFields;

    // Whether to hydrate results into entity objects
    protected bool _hydrate = true;

    // Whether aliases are generated for fields.
    protected bool _aliasingEnabled = true;
}