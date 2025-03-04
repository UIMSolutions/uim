module uim.databases.mixins.field;

import uim.databases;

@safe:

// Contains the field property with a getter and a setter for it
mixin template TField() {
    /**
     * The field name or expression to be used in the left hand side of the operator
     *
     * @var \UIM\Database\/* IExpression| * / string[]
      */
    protected /* IExpression| */ string[] _field;

    /**
     * Sets the field name
     * Params:
     * \UIM\Database\/* IExpression| * / string[] afield The field to compare with.
     */
    void setFieldNames(/* IExpression| */ string[] afield) {
       _field = field;
    }
    
    // Returns the field name
    /* IExpression| * / string[] getFieldNames() {
        return _field;
    } */
}
