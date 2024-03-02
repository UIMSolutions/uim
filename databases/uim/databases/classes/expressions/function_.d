module uim.databases.classes.expressions.function_x;

import uim.databases;

@safe:

/**
 * This class represents a auto call string in a SQL statement. Calls can be
 * constructed by passing the name of the auto and a list of params.
 * For security reasons, all params passed are quoted by default unless
 * explicitly told otherwise.
 */
class FunctionExpression : QueryExpression, ITypedResult {
    use ExpressionTypeCasterTrait;
    use TypedResultTrait;

    // The name of the auto to be constructed when generating the SQL string
    mixin(TPropperty!("string", "name"));

    /**
     * Constructor. Takes a name for the auto to be invoked and a list of params
     * to be passed into the function. Optionally you can pass a list of types to
     * be used for each bound param.
     *
     * By default, all params that are passed will be quoted. If you wish to use
     * literal arguments, you need to explicitly hint this function.
     *
     * ### Examples:
     *
     * `$f = new FunctionExpression("CONCAT", ["UIM", " rules"]);`
     *
     * Previous line will generate `CONCAT("UIM", " rules")`
     *
     * `$f = new FunctionExpression("CONCAT", ["name": 'literal", " rules"]);`
     *
     * Will produce `CONCAT(name, " rules")`
     * Params:
     * string aName the name of the auto to be constructed
     * @param array $params list of arguments to be passed to the function
     * If associative the key would be used as argument when value is 'literal'
     * @param STRINGAA|array<string|null> types Associative array of types to be associated with the
     * passed arguments
     * @param string resultType The return type of this expression
     */
    this(string aName, array $params = [], array types = [], string resultType = "string") {
       _name = name;
       _returnType = resultType;
        super($params, types, ",");
    }

    /**
     * Adds one or more arguments for the auto call.
     * Params:
     * \UIM\Database\IExpression|string[] aconditions list of arguments to be passed to the function
     * If associative the key would be used as argument when value is 'literal'
     * @param STRINGAA types Associative array of types to be associated with the
     * passed arguments
     * @param bool $prepend Whether to prepend or append to the list of arguments
     * @see \UIM\Database\Expression\FunctionExpression.__construct() for more details.

     * @psalm-suppress MoreSpecificImplementedParamType
     */
    void add(IExpression|string[] aconditions, array types = [], bool $prepend = false) {
        $put = $prepend ? "array_unshift' : 'array_push";
        typeMap = this.getTypeMap().setTypes($types);

        $conditions.byKeyValue
            .each!(kv => addCondtion(conditions, kv.key, kv.value));
    }

    protected addCondition(string key, string condition) {
            if (condition == "literal") {
                $put(_conditions, key);
                return;
            }
            if (condition == "identifier") {
                $put(_conditions, new IdentifierExpression(key));
                return;
            }
            type = typeMap.type(myKey);

            if ($type !isNull && !cast(IExpression)$p ) {
                condition = _castToExpression($p, type);
            }
            if (cast(IExpression)condition) {
                $put(_conditions, condition);
                return;
            }
            $put(_conditions, ["value": condition, "type": type]);
    }
 
    string sql(ValueBinder aBinder) {
        someParts = [];
        foreach ($condition; _conditions) {
            if (cast(Query)$condition) {
                $condition = "(%s)".format($condition.sql(aBinder));
            } elseif (cast(IExpression)$condition ) {
                $condition = $condition.sql(aBinder);
            } elseif (isArray($condition)) {
                $p = aBinder.placeholder("param");
                aBinder.bind($p, $condition["value"], $condition["type"]);
                $condition = $p;
            }
            someParts ~= $condition;
        }
        return _name ~ "(%s)".format(join(
           _conjunction ~ " ",
            someParts
        ));
    }
    
    /**
     * The name of the bool is in itself an expression to generate, thus
     * always adding 1 to the amount of expressions stored in this object.
     */
    size_t count() {
        return 1 + count(_conditions);
    }
}
