module uim.databases.classes.expressions.between;

import uim.databases;

@safe:

// An expression object that represents a SQL BETWEEN snippet
class DBetweenExpression : DExpression { // TODO}, IField {
    mixin(ExpressionThis!("Between"));
    mixin TField;

    /* 
    mixin TExpressionTypeCaster;

    // The first value in the expression
    protected Json _from;

    /**
     * The second value in the expression
     *
     * @var mixed
     * /
    protected Json _to;

    // The data valueType for the from and to arguments
    protected Json _type;

    /**
     * Constructor
     * Params:
     * \UIM\Database\IExpression|string fieldName The field name to compare for values inbetween the range.
     * @param string|null typeName The data typeName name to bind the values with.
     * /
    this(IExpression|string fieldName, Json fromValue, Json toValue, string typeName = null) {
        if (!typeName.isNull) {
            from = _castToExpression(fromValue, typeName);
            to = _castToExpression(toValue, typeName);
        }
       _field = fieldName;
       _from = fromValue;
       _to = toValue;
       _type = typeName;
    }
 
    string sql(DValueBinder aValueBinder) {
        auto someParts = [
            "from": _from,
            "to": _to,
        ];

        auto field = _field;
        if (cast(IExpression)field ) {
            field = field.sql(aValueBinder);
        }
        foreach (name: part; someParts) {
            if (cast(IExpression)part) {
                someParts[name] = part.sql(aValueBinder);
                continue;
            }
            someParts[name] = _bindValue(part, aValueBinder, _type);
        }
        assert(isString(field));

        return "%s BETWEEN %s AND %s".format(field, someParts["from"], someParts["to"]);
    }
 
    void traverse(Closure aCallback) {
        [_field, _from, _to]
            .map!(part => auto expression = cast(IExpression)part)
            .each!(expression => aCallback(expression));
    }

    /**
     * Registers a value in the placeholder generator and returns the generated placeholder
     * Params:
     * Json aValue The value to bind
     * @param \UIM\Database\DValueBinder aValueBinder The value binder to use
     * /
    protected string _bindValue(Json aValue, DValueBinder aValueBinder, string valueType) {
        placeholder = aValueBinder.placeholder("c");
        aValueBinder.bind(placeholder, aValue, valueType);

        return placeholder;
    }

    // Do a deep clone of this expression.
    void clone() {
        ["_field", "_from", "_to"]
            .filter!(part => cast(IExpression)this.{part})
            .each!(part => this.{part} = clone this.{part});
    } */
}
mixin(ExpressionCalls!("Between"));
