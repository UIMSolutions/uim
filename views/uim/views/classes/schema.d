module uim.views.classes.schema;

import uim.views;

@safe:

// Contains the schema information for Form instances.
class DSchema : UIMObject {

    this() {
        super(this.classname);
    }

    this(Json[string] initData) {
        super(initData);
    }

    this(string newName) {
        super(newName);
    }

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
return false;
}

        _fieldDefaults = createMap!(string, Json)
            .set("type", Json(null))
            .set("length", Json(null))
            .set("precision", Json(null))
            .set("default", Json(null));

        return true;
    }

    // The fields in this schema.
    protected Json[string] _fields;

    // The default values for fields.
    protected Json[string] _fieldDefaults;

    // #region fields
    // Removes a field to the schema.
    // Get the list of fields in the schema.
    string[] fieldNames() {
        return _fields.keys;
    }

    // Add multiple fields to the schema.
    DSchema addFields(Json[string] fields) {
        fields.byKeyValue
            .each!(field => addField(field.key, field.value));

        return this;
    }

    // Adds a field to the schema.
    DSchema addField(string key, Json attributes) {
        _fields.set(key,  attributes.merge(_fieldDefaults));

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
        _fields.removeKey(fieldName);
        return this;
    }
    // #endregion fields

    // Get the printable version of this object
    Json[string] debugInfo() {
        /* return [
            "_fields": _fields.toString,
        ]; */
        return null; 
    }
}

auto Schema() {
    return new DSchema;
}

unittest {
    STRINGAA[string] fields;
    fields.set("a", [
            "type": Json(null),
            "length": Json(null),
            "precision": Json(null),
            "default": Json(null),
        ]);

    fields.set("b", [
            "type": Json(null),
            "length": Json(null),
            "default": Json(null),
        ]);

    fields.set("c", [
            "type": Json(null),
            "length": Json(null),
            "default": Json(null),
        ]);

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
