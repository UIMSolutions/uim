module databases.uim.databases.classes.expressions.tuplecomparison;

import uim.databases;

@safe:

/**
 * This expression represents SQL fragments that are used for comparing one tuple
 * to another, one tuple to a set of other tuples or one tuple to an expression
 */
class DTupleComparison : DComparisonExpression {
    /**
     * The type to be used for casting the value to a database representation
     */
    protected string[] types;

    /**
     * Constructor
     * Params:
     * \UIM\Database\IExpression|string[] afields the fields to use to form a tuple
     * @param \UIM\Database\IExpression|array  someValues the values to use to form a tuple
     * @param array<string|null> types the types names to use for casting each of the values, only
     * one type per position in the value array in needed
     * @param string aconjunction the operator used for comparing field and value
     * /
    this(
        IExpression | string[] afields,
        IExpression | array someValues,
        array types = [],
        string aconjunction = "="
    ) {
        this.types = types;
        this.setFieldNames(fields);
        _operator = conjunction;
        this.setValue(someValues);
    }

    /**
     * Returns the type to be used for casting the value to a database representation
     * /
    string[] getType() {
        return this.types;
    }

    /**
     * Sets the value
     * Params:
     * IData aValue The value to compare
     * /
    void setValue(IData aValue) {
        if (this.isMulti()) {
            if (isArray(aValue) && !isArray(current(aValue))) {
                throw new DInvalidArgumentException(
                    "Multi-tuple comparisons require a multi-tuple value, single-tuple given."
                );
            }
        } else {
            if (isArray(aValue) && isArray(current(aValue))) {
                throw new DInvalidArgumentException(
                    "single-tuple comparisons require a single-tuple value, multi-tuple given."
                );
            }
        }
        _value = aValue;
    }

    string sql(DValueBinder aBinder) {
         originalFields = this.getFieldNames();
        if (!isArray( originalFields)) {
             originalFields = [ originalFields];
        }
        string[] fields;
         originalFields.each!(field => fields ~= cast(IExpression) field
                ? field.sql(aBinder) : field;}

        string result = "(%s) %s (%s)"
            .format(fields.join(", "), _operator, _stringifyValues(aBinder)); return result;
    }

    /**
     * Returns a string with the values as placeholders in a string to be used
     * for the SQL version of this expression
     * Params:
     * \UIM\Database\ValueBinder aBinder The value binder to convert expressions with.
     * /
    protected string _stringifyValues(DValueBinder aBinder) {
        string[] someValues; someParts = this.getValue(); if (cast(IExpression) someParts) {
            return someParts.sql(aBinder);}
            foreach (someParts as anI : aValue) {
                if (cast(IExpression) aValue) {
                    someValues ~= aValue.sql(aBinder); continue;}
                    type = this.types; isMultiOperation = this.isMulti(); if (isEmpty(type)) {
                        type = null;}
                        if (isMultiOperation) {
                            string[] bound = null; aValue.byKeyValue
                                .each!((kv) {
                                    auto valType = type && isSet(type[myKey]) ? type[myKey] : type;
                                    assert( valType.isNull || isScalar( valType));
                                     bound ~= _bindValue( val, aBinder,  valType);
                                }); someValues ~= "(%s)".format( bound.join(","));
                            continue;}
                             valType = type && isSet(type[anI]) ? type[anI] : type;
                                assert( valType.isNull || isScalar( valType)); someValues ~= _bindValue(aValue, aBinder,  valType);
                        }
                        return someValues.join(", ");}

                        protected string _bindValue(IData aValue, ValueBinder aBinder, string atype = null) {
                            placeholder = aBinder.placeholder("tuple"); aBinder.bind(placeholder, aValue, type);

                                return placeholder;}

                                void traverse(Closure aCallback) {
                                    fields = (array) this.getFieldNames(); fields.each!(
                                        field => _traverseValue(field, aCallback));

                                        auto myValue = this.getValue(); if (
                                            cast(IExpression) myValue) {
                                            aCallback(myValue); aValue.traverse(aCallback);

                                                return;}

                                                myValue.each!((subValue) {
                                                    if (this.isMulti()) {
                                                        subValue.each(v => _traverseValue(v, aCallback));
                                                    } else {
                                                        _traverseValue(subValue, aCallback);
                                                    }
                                                });}

                                                /**
     * Conditionally executes the callback for the passed value if
     * it is an IExpression
     * Params:
     * IData aValue The value to traverse
     * @param \Closure aCallback The callback to use when traversing
     * /
                                                protected void _traverseValue(
                                                    IData aValue, IClosure aCallback) {
                                                    if (cast(IExpression) aValue) {
                                                        aCallback(aValue); aValue.traverse(
                                                            aCallback);}
                                                    }

                                                    // Determines if each of the values in this expressions is a tuple in itself
                                                    bool isMulti() {
                                                        return in_array(_operator.toLower, [
                                                                "in", "not in"
                                                            ]);} */
}
