module uim.databases.classes.expressions.function_;

import uim.databases;

@safe:

/**
 * This class represents a auto call string in a SQL statement. Calls can be
 * constructed by passing the name of the auto and a list of params.
 * For security reasons, all params passed are quoted by default unless
 * explicitly told otherwise.
 */
class DFunctionExpression : DExpression { // TODO }: QueryExpression, ITypedResult {
    mixin(ExpressionThis!("Function"));
    mixin TExpressionTypeCaster;
    mixin TypedResultTemplate;

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
     * `f = new DFunctionExpression("CONCAT", ["UIM", " rules"]);`
     *
     * Previous line will generate `CONCAT("UIM", " rules")`
     *
     * `f = new DFunctionExpression("CONCAT", ["name": 'literal", " rules"]);`
     *
     * Will produce `CONCAT(name, " rules")`
     * Params:
     * @param Json[string] arguments list of arguments to be passed to the function
     * If associative the key would be used as argument when value is 'literal'
     * @param STRINGAA|array<string|null> types Associative array of types to be associated with the
     * passed arguments
     * @param string resultType The return type of this expression
     * /
    this(string newName, Json[string] arguments = [], Json[string] types = [], string resultType = "string") {
       this.name(newName);
       _returnType = resultType;
        super(arguments, types, ",");
    }

    /**
     * Adds one or more arguments for the auto call.
     * Params:
     * \UIM\Database\IExpression|string[] aconditions list of arguments to be passed to the function
     * If associative the key would be used as argument when value is 'literal'
     * @param STRINGAA types Associative array of types to be associated with the
     * passed arguments
     * @param bool prepend Whether to prepend or append to the list of arguments
     * @see \UIM\Database\Expression\FunctionExpression.__construct() for more details.

     * @psalm-suppress MoreSpecificImplementedParamType
     * /
    void add(IExpression|string[] aconditions, Json[string] types = [], bool prepend = false) {
        put = prepend ? "array_unshift' : 'array_push";
        typeMap = this.getTypeMap().setTypes(types);

        conditions.byKeyValue
            .each!(kv => addCondtion(conditions, kv.key, kv.value));
    }

    protected addCondition(string key, string condition) {
            if (condition == "literal") {
                put(_conditions, key);
                return;
            }
            if (condition == "identifier") {
                put(_conditions, new DIdentifierExpression(key));
                return;
            }
            
            quto type = typeMap.type(myKey);
            if (!type.isNull && !cast(IExpression)p ) {
                condition = _castToExpression(p, type);
            }
            if (cast(IExpression)condition) {
                put(_conditions, condition);
                return;
            }
            put(_conditions, ["value": condition, "type": type]);
    }
 
    string sql(DValueBinder aBinder) {
        string[] someParts;
        _conditions.each!((condition) {
            if (cast(Query)condition) {
                condition = "(%s)".format(condition.sql(aBinder));
            } elseif (cast(IExpression)condition ) {
                condition = condition.sql(aBinder);
            } elseif (isArray(condition)) {
                p = aBinder.placeholder("param");
                aBinder.bind(p, condition["value"], condition["type"]);
                condition = p;
            }
            someParts ~= condition;
        });
        return _name ~ "(%s)".format(someParts.join(_conjunction ~ " "));
    }
    
    /**
     * The name of the bool is in itself an expression to generate, thus
     * always adding 1 to the amount of expressions stored in this object.
     * /
    size_t count() {
        return 1 + count(_conditions);
    } */
}
mixin(ExpressionCalls!("Function"));
