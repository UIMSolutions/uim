module uim.datasources.classes.entities.entity;

import uim.datasources;

@safe:

class DDatasourceEntity : UIMObject, IDatasourceEntity {
    mixin(DatasourceEntityThis!());

    // Holds all fields and their values for this entity.
    protected Json[string] _fields;

    // Holds all fields that have been changed and their original values for this entity.
    protected Json[string] _original;

    // List of field names that should not be included in Json or Array representations of this Entity.
    protected string[] _hidden;

    // Indicates whether this entity is yet to be persisted.
    // Entities default to assuming they are new. You can use Table.persisted()
    // to set the new flag on an entity based on records in the database.
    protected bool _new = true;

    /*
     * List of computed or virtual fields that should be included in Json or array
     * representations of this Entity. If a field is present in both _hidden and _virtual
     * the field will not be in the array/Json versions of the entity. */
    protected string[] _virtual = null;

    // Holds a list of the fields that were modified or added after this object was originally created.
    protected bool[string] _changed;

}

unittest {
    // TODO
}
