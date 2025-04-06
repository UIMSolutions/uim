module uim.datasources.classes.entities.entity;

import uim.datasources;

@safe:

class DDatasourceEntity : UIMObject, IDatasourceEntity {
    mixin(DatasourceEntityThis!());

    // Holds all fields and their values for this entity.
    protected Json[string] _fields;

    // Holds all fields that have been changed and their original values for this entity.
    protected Json[string] _original;

    // #region hiddenFields
    // List of field names that should not be included in Json or Array representations of this Entity.
    protected string[] _hiddenFields;
    string[] hiddenFields() {
        return _hiddenFields;
    }
    IDatasourceEntity hiddenFields(string[] fields) {
        _hiddenFields = fields;
        return this;
    }
    IDatasourceEntity addHiddenFilde(string field) {
        if (_hiddenFields is null) {
            _hiddenFields = new string[];
        }
        _hiddenFields ~= field;
        return this;
    }
    
    mixin(RemoveMethods!("IDatasourceEntity", "HiddenFields", "HiddenField", "string"));

    IDatasourceEntity removeHiddenField(string field) {
        if (_hiddenFields is null) {
            return this;
        }
        _hiddenFields.removeValue(field);
        return this;
    }
    unittest {
        auto entity = new DDatasourceEntity();
        entity.addHiddenField("password");
        assert(entity.hiddenFields.length == 1);
        assert(entity.hiddenFields[0] == "password");

        entity.removeHiddenField("password");
        assert(entity.hiddenFields.length == 0);

        entity.addHiddenFields(["password", "username"]);
        assert(entity.hiddenFields.length == 2);
        assert(entity.hiddenFields[0] == "password");

        entity.removeHiddenFields(["password", "username"]);
        assert(entity.hiddenFields.length == 0);

        entity.addHiddenFields("password", "username");
        assert(entity.hiddenFields.length == 2);
        assert(entity.hiddenFields[0] == "password");

        entity.removeHiddenFields("password", "username");
        assert(entity.hiddenFields.length == 0);
    }
    // #endregion hiddenFields


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
