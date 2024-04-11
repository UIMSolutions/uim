module uim.databases.interfaces.field;

import uim.databases;

@safe:

/**
 * Describes a getter and a setter for the a field property. Useful for expressions
 * that contain an identifier to compare against.
 */
interface IField {
    // Set field name
    void setFieldNames(IExpression fieldName);
    void setFieldNames(string[] fieldName);

    // Get field names
    string[] getFieldNames();
}
