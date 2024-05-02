module uim.views.classes.schema;

import uim.views;

@safe:

// Contains the schema information for Form instances.
class DSchema {
    mixin TConfigurable;

    this() {
        initialize;
        this.name(this.className);
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    this(string newName) {
        this();
        this.name(newName);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);
        
        return true;
    }

    mixin(TProperty!("string", "name"));

    // The fields in this schema.
    protected STRINGAA[string] _fields;

    // The default values for fields.
    protected STRINGAA _fieldDefaults = [
        "type": null,
        "length": null,
        "precision": null,
        "default": null,
    ];

    // #region fields
        // Removes a field to the schema.
        // Get the list of fields in the schema.
        string[] fieldNames() {
            return _fields.keys;
        }

        // Add multiple fields to the schema.
        DSchema addFields(STRINGAA[string] fields) {
            fields.byKeyValue
                .each!(kv => this.addField(kv.key, kv.value));
            return this;
        }

        // Adds a field to the schema.
        DSchema addField(string fieldName, STRINGAA fieldAttributes) {
            _fields[fieldName] = fieldAttributes.merge(_fieldDefaults);
            return this;
        }

        bool hasAnyFields(string[] fieldNames) {
            return fieldNames.any!(field => hasField(field));
        }

        bool hasAllFields(string[] fieldNames) {
            return fieldNames.all!(field => hasField(field));
        }

        bool hasField(string fieldName) {
            return fieldName in _fields ? true : false;
        }

        // Get the type of the named field.
        string fieldType(string fieldName) {
            auto foundField = this.field(fieldName);
            if (!foundField) {
                return null;
            }

            return foundField.get("type", null);
        }

        // Get the type of the named field.
        string fieldDefault(string fieldName) {
            auto foundField = this.field(fieldName);
            if (!foundField) {
                return null;
            }

            return foundField.get("default", null);
        }

        // Get the attributes for a given field.
        STRINGAA field(string fieldName) {
            return _fields.get(fieldName, null);
        }

        DSchema removeField(string fieldName) {
            _fields.remove(fieldName);
            return this;
        }
    // #endregion fields

    // Get the printable version of this object
    Json[string] debugInfo() {
        return [
            "_fields": _fields.toString,
        ];
    } 
}
auto Schema() {
    return new DSchema;
}

unittest {
    STRINGAA[string] fields;
    fields["a"] = [
        "type": null,
        "length": null,
        "precision": null,
        "default": null,
    ];

    fields["b"] = [
        "type": null,
        "length": null,
        "default": null,
    ];

    fields["c"] = [
        "type": null,
        "length": null,
        "default": null,
    ];

    auto schema = Schema.addFields(fields);
    assert(schema.hasField("a"), "Field a is missing");
    assert(schema.hasAnyFields(["a", "b", "c"]), "Fields a, b, c are missing");
    assert(!schema.hasAnyFields(["x", "y", "z"]), "Fields a, b, c are missing");
    assert(schema.hasAllFields(["a", "b", "c"]), "Field a, b or c are missing");
    assert(!schema.hasAllFields(["a", "b", "c", "d"]), "Field a, b or c are missing");

    schema.removeField("b");
    assert(schema.hasField("a"), "Field a is missing");
    assert(!schema.hasField("b"), "Field b still exists");
    assert(schema.hasAnyFields(["a", "b", "c"]), "Fields a, b, c are missing");
    assert(!schema.hasAnyFields(["x", "y", "z"]), "Fields a, b, c are missing");
    assert(schema.hasAllFields(["a", "c"]), "Field a or c are missing");
    assert(!schema.hasAllFields(["a", "b", "c"]), "Field a, b or c are missing");
}