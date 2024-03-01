module uim.databases.expressions.fieldinterfaces;

import uim.databases;

@safe:

/**
 * Describes a getter and a setter for the a field property. Useful for expressions
 * that contain an identifier to compare against.
 */
interface IField {
    // Set field name
    void setFieldNames(IExpression fieldName);
    void setFieldNames(IExpression|string[] fieldName);

    // Get field names
    IExpression|string[] getFieldNames();
}
