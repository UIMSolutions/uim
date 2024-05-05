module uim.databases.classes.expressions.comparison;

import uim.databases;

@safe:

/**
 * A Comparison is a type of query expression that represents an operation
 * involving a field an operator and a value. In its most common form the
 * string representation of a comparison is `field = value`
 */
class DComparisonExpression : DExpression { // TODO}, IField {
    mixin(ExpressionThis!("Comparison"));
    mixin TField;

    /*
    mixin TExpressionTypeCaster;

    // The value to be used in the right hand side of the operation
    protected Json _value;

    // The type to be used for casting the value to a database representation
    protected string _type = null;

    // The operator used for comparing field and value
    protected string _operator = "=";

    // Whether the value in this expression is a traversable
    protected bool _isMultiple = false;

    /**
     * A cached list of IExpression objects that were
     * found in the value for this expression.
     * /
    protected IExpression[] _valueExpressions;

    /**
     * Constructor
     * Params:
     * \UIM\Database\IExpression|string afield the field name to compare to a value
     * @param Json aValue The value to be used in comparison
     * /
    this(
        IExpression|string afield,
        Json aValue,
        string typeName = null,
        string operator = "="
    ) {
       _type = typeName;
        this.setFieldNames(field);
        this.setValue(aValue);
       _operator = operator;
    }
    
    /**
     * Sets the value
     * Params:
     * Json aValue The value to compare
     * /
    void setValue(Json aValue) {
        aValue = _castToExpression(aValue, _type);

         isMultiple = _type && _type.has("[]");
        if (isMultiple) {
            [aValue, _valueExpressions] = _collectExpressions(aValue);
        }
       _isMultiple = isMultiple;
       _value = aValue;
    }
    
    // Returns the value used for comparison
    Json getValue() {
        return _value;
    }
    
    // Sets the operator to use for the comparison
    void setOperator(string operator) {
       _operator = operator;
    }
    
    // Returns the operator used for comparison
    string getOperator() {
        return _operator;
    }
 
    string sql(DValueBinder aBinder) {
        auto field = _field;

        if (cast(IExpression)field ) {
            field = field.sql(aBinder);
        }
        if (cast(IdentifierExpression)_value) {
            template = "%s %s %s";
            aValue = _value.sql(aBinder);
        } elseif (cast(IExpression)_value ) {
            template = "%s %s (%s)";
            aValue = _value.sql(aBinder);
        } else {
            [template, aValue] = _stringExpression(aBinder);
        }
        assert(isString(field));

        return template.format(field, _operator, aValue);
    }
 
    void traverse(Closure aCallback) {
        if (cast(IExpression)_field ) {
            aCallback(_field);
           _field.traverse(aCallback);
        }
        if (cast(IExpression)_value ) {
            aCallback(_value);
           _value.traverse(aCallback);
        }
        _valueExpressions.each!((value) {
            aCallback(value);
            value.traverse(aCallback);
        });
    }
    
    // Create a deep clone.
    void clone() {
        ["_value", "_field"]
            .filter!(prop => cast(IExpression)this.{prop})
            .each!(prop => this.{prop} = clone this.{prop});
    }
    
    /**
     * Returns a template and a placeholder for the value after registering it
     * with the placeholder aBinder
     * Params:
     * \UIM\Database\DValueBinder aBinder The value binder to use.
     * /
    // TODO protected Json[string] _stringExpression(DValueBinder valueBinder) {
        auto template = "%s ";

        if (cast(IExpression)_field  && !cast(IdentifierExpression)_field) {
            template = "(%s) ";
        }
        if (_isMultiple) {
            template ~= "%s (%s)";
            type = _type;
            if (type !isNull) {
                type = type.replace("[]", "");
            }
            aValue = _flattenValue(_value, valueBinder, type);

            // To avoid SQL errors when comparing a field to a list of empty values,
            // better just throw an exception here
            if (aValue == "") {
                string field = cast(IExpression)_field  ? _field.sql(valueBinder): _field;
                throw new DatabaseException(
                    "Impossible to generate condition with empty list of values for field (%s)".format(field)
                );
            }
        } else {
            template ~= "%s %s";
            aValue = _bindValue(_value, valueBinder, _type);
        }
        return [template, aValue];
    }
    
    /**
     * Registers a value in the placeholder generator and returns the generated placeholder
     * Params:
     * Json aValue The value to bind
     * @param \UIM\Database\DValueBinder valueBinder The value binder to use
     * @param string|null type The type of aValue
     * /
    protected string _bindValue(Json aValue, DValueBinder valueBinder, string valueType = null) {
        auto placeholder = valueBinder.placeholder("c");
        valueBinder.bind(placeholder, valueBinder, valueType);

        return placeholder;
    }
    
    /**
     * Converts a traversable value into a set of placeholders generated by
     * aBinder and separated by `,`
     * Params:
     * range aValue the value to flatten
     * @param \UIM\Database\DValueBinder aBinder The value binder to use
     * @param string|null type the type to cast values to
     * /
    protected string _flattenValue(Range aValue, DValueBinder aBinder, string atype = null) {
        STRINGAA someParts;
        if (isArray(aValue)) {
            _valueExpressions.byKeyValue
                .each!((kv) {
                    someParts[kv.key] = kv.value.sql(aBinder);
                    unset(aValue[kv.key]);
                });
        }

        if (!aValue.isEmpty) {
            someParts += aBinder.generateManyNamed(aValue, type);
        }
        return someParts.join(","); // ??
    }
    
    /**
     * Returns an array with the original  someValues in the first position
     * and all IExpression objects that could be found in the second
     * position.
     * Params:
     * \UIM\Database\IExpression|range  someValues The rows to insert
     * /
    // TODO protected Json[string] _collectExpressions(IExpression|range  someValues) {
        if (cast(IExpression)someValues ) {
            return [someValues, []];
        }
    }
    // TODO protected Json[string] _collectExpressions(Range  someValues) {
        someExpressions = auto result;
         isArray = isArray(someValues);

        if (isArray) {
            result = (array)someValues;
        }
        someValues.byKeyValue
            .each!((kv) {
                if (cast(IExpression)kv.value) {
                    someExpressions[kv.key] = kv.value;
                }
                if (isArray) {
                    result[kv.key] = kv.value;
                }
            });

        return [result, someExpressions];
    } */
}
mixin(ExpressionCalls!("Comparison"));
