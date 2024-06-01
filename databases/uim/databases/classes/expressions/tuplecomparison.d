module uim.databases.classes.expressions.tuplecomparison;

import uim.databases;

@safe:

/**
 * This expression represents SQL fragments that are used for comparing one tuple
 * to another, one tuple to a set of other tuples or one tuple to an expression
 */
class DTupleComparisonExpression : DComparisonExpression {
    mixin(ExpressionThis!("TupleComparison"));

    // The type to be used for casting the value to a database representation
    protected string[] types;

    this(
        IExpression | string[] fieldNames,
        IExpression | Json[string] someValues,
        Json[string] typesNames = null,
        string compareOperator = "="
    ) {
        this.typesNames = typesNames;
        setFieldNames(fields);
        _operator = compareOperator;
        setValue(someValues);
    }

    // Returns the type to be used for casting the value to a database representation
    string[] getType() {
        return _types;
    }

    // Sets the value
    void setValue(Json valueToCompare) {
        if (this.isMulti()) {
            if (isArray(valueToCompare) && !isArray(current(valueToCompare))) {
                throw new DInvalidArgumentException(
                    "Multi-tuple comparisons require a multi-tuple value, single-tuple given."
                );
            }
        } else {
            if (isArray(valueToCompare) && isArray(current(valueToCompare))) {
                throw new DInvalidArgumentException(
                    "single-tuple comparisons require a single-tuple value, multi-tuple given."
                );
            }
        }
        _value = valueToCompare;
    }

    string sql(DValueBinder valueBinder) {
        auto originalFields = getFieldNames();
        if (!isArray(originalFields)) {
            originalFields = [originalFields];
        }
        string[] fieldNames;
        originalFields.each!(field => fieldNames ~= cast(IExpression)field
                ? field.sql(valueBinder) 
                : field;
                );

        return "(%s) %s (%s)"
            .format(fields.join(", "), _operator, _stringifyValues(valueBinder));}

        /**
     * Returns a string with the values as placeholders in a string to be used
     * for the SQL version of this expression
     */
        protected string _stringifyValues(DValueBinder valueBinder) {
            string[] someValues; 
            someParts = getValue(); 
            if (cast(IExpression) someParts) {
                return someParts.sql(valueBinder);
                }
                foreach (someParts as anI : aValue) {
                    if (cast(IExpression) aValue) {
                        someValues ~= aValue.sql(valueBinder); 
                        continue;
                        }
                        type = this.typesNames; isMultiOperation = this.isMulti();
                            if (isEmpty(type)) {
                                type = null;}
                                if (isMultiOperation) {
                                    string[] bound = null; aValue.byKeyValue
                                        .each!((kv) {
                                            auto valType = type && type.hasKey(myKey) ? type[myKey]
                                                : type;
                                            assert(valType.isNull || isScalar(valType));
                                            bound ~= _bindValue(val, valueBinder, valType);
                                        }); someValues ~= "(%s)".format(bound.join(","));
                                    continue;}
                                    valType = type && isSet(type[anI]) ? type[anI] : type;
                                        assert(valType.isNull || isScalar(valType));
                                        someValues ~= _bindValue(aValue, valueBinder, valType);
                                }
                                return someValues.join(", ");}

                                protected string _bindValue(Json aValue, DValueBinder valueBinder, string atype = null) {
                                    placeholder = valueBinder.placeholder("tuple");
                                        valueBinder.bind(placeholder, aValue, type);

                                        return placeholder;}

                                        void traverse(Closure aCallback) {
                                            fields = (array) getFieldNames(); fields.each!(
                                                field => _traverseValue(field, aCallback));

                                                auto myValue = getValue(); if (
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
     * Json aValue The value to traverse
     */
                                                        protected void _traverseValue(
                                                            Json traverseToTraverse, IClosure callbackForTraversing) {
                                                            if (cast(IExpression) traverseToTraverse) {
                                                                callbackForTraversing(traverseToTraverse);
                                                                    traverseToTraverse.traverse(
                                                                        callbackForTraversing);
                                                            }
                                                        }

                                                    // Determines if each of the values in this expressions is a tuple in itself
                                                    bool isMulti() {
                                                        return in_array(_operator.lower, [
                                                                "in", "not in"
                                                            ]);}
                                                    }
                                                    mixin(ExpressionCalls!("TupleComparison"));
