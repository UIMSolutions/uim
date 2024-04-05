module uim.forms.classes.schema;

import uim.forms;

@safe:

// Contains the schema information for Form instances.
class DSchema {
    // The fields in this schema.
    protected STRINGAA[string] _fields;

    // The default values for fields.
    protected STRINGAA[string] _fieldDefaults = [
        "type": null,
        "length": null,
        "precision": null,
        "default": null,
    ];

    // #region fields
        // Removes a field to the schema.
        // Get the list of fields in the schema.
        string[] fieldNames() {
            return _fields;
        }

        // Add multiple fields to the schema.
        void addFields(STRINGAA[string] fields) {
            fields.byKeyValue
                .each!(kv => this.addField(kv.key, kv.value));
        }

        // Adds a field to the schema.
        void addField(string fieldName, STRINGAA[string] fieldAttributes) {
            _fields[fieldName] = fieldAttributes.merge(_fieldDefaults);
        }

        // Get the type of the named field.
        string fieldType(string aName) {
            auto foundField = this.field(name);
            if (!foundField) {
                return null;
            }
            return foundField["type"];
        }

        // Get the attributes for a given field.
        STRINGAA[string] field(string fieldName) {
            return _fields.get(fieldName, null);
        }

        void removeField(string fieldName) {
            _fields.remove(fieldName);
        }
    // #endregion fields

    // Get the printable version of this object
    string[string] debugInfo() {
        return [
            "_fields": _fields.toString,
        ];
    } 
}
