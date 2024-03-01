module uim.databases.Expression;

import uim.databases;

@safe:

// An expression object that represents a SQL BETWEEN snippet
class BetweenExpression : IExpression, IField {
    use ExpressionTypeCasterTrait;
    use FieldTrait;

    // The first value in the expression
    protected Json _from;

    /**
     * The second value in the expression
     *
     * @var mixed
     */
    protected Json _to;

    // The data type for the from and to arguments
    protected Json _type;

    /**
     * Constructor
     * Params:
     * \UIM\Database\IExpression|string afield The field name to compare for values inbetween the range.
     * @param Json $from The initial value of the range.
     * @param Json to The ending value in the comparison range.
     * @param string|null type The data type name to bind the values with.
     */
    this(IExpression|string afield, Json $from, Json to, string atype = null) {
        if (!$type.isNull) {
            $from = _castToExpression($from, type);
            to = _castToExpression($to, type);
        }
       _field = field;
       _from = $from;
       _to = to;
       _type = type;
    }
 
    string sql(ValueBinder aValueBinder) {
        auto someParts = [
            "from": _from,
            "to": _to,
        ];

        auto field = _field;
        if (cast(IExpression)field ) {
            field = field.sql(aValueBinder);
        }
        foreach (name: $part; someParts) {
            if (cast(IExpression)$part) {
                someParts[name] = $part.sql(aValueBinder);
                continue;
            }
            someParts[name] = _bindValue($part, aValueBinder, _type);
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
     * @param \UIM\Database\ValueBinder aValueBinder The value binder to use
     * @param string atype The type of aValue
     */
    protected string _bindValue(Json aValue, ValueBinder aValueBinder, string atype) {
        $placeholder = aValueBinder.placeholder("c");
        aValueBinder.bind($placeholder, aValue, type);

        return $placeholder;
    }

    // Do a deep clone of this expression.
    void __clone() {
        ["_field", "_from", "_to"]
            .filter!(part => cast(IExpression)this.{$part})
            .each!(part => this.{$part} = clone this.{$part});
    }
}
