module uim.databases.classes.expressions.whenthen;

import uim.databases;

@safe:

/**
 * Represents a SQL when/then clause with a fluid API
 */
class DWhenThenExpression : DExpression {
    mixin(ExpressionThis!("WhenThen"));

    mixin TCaseExpression;
    mixin TExpressionTypeCaster;

    /**
     * The names of the clauses that are valid for use with the
     * `clause()` method.
     */
    protected string[]  validClauseNames = [
        "when",
        "then",
    ];

    // The type map to use when using an array of conditions for the `WHEN` value.
    protected ITypeMap _typeMap;

    /**
     * Then `WHEN` value.
     *
     * @var \UIM\Database\IExpression|object|scalar|null
     */
    protected Json when = null;

    // The `WHEN` value type.
    protected string[]  whenType = null;

    /**
     * The `THEN` value.
     *
     * @var \UIM\Database\IExpression|object|scalar|null
     */
    protected Json then = null;

    /**
     * Whether the `THEN` value has been defined, eg whether `then()`
     * has been invoked.
     */
    protected bool $hasThenBeenDefined = false;

    // The `THEN` result type.
    protected string athenType = null;

    this(DTypeMap typeMap = null) {
       _typeMap = typeMap ?  new DTypeMap();
    }
    
    /**
     * Sets the `WHEN` value.
     * Params:
     * /* object */ string[]|float|bool when The `WHEN` value. When using an array of
     * conditions, it must be compatible with `\UIM\Database\Query.where()`. Note that this argument is _not_
     * completely safe for use with user data, as a user supplied array would allow for raw SQL to slip in!If you
     * plan to use user data, either pass a single type for the `type` argument (which forces the ` when` value to be
     * a non-array, and then always binds the data), use a conditions array where the user data is only passed on the
     * value side of the array entries, or custom bindings!
     */
    void when(string[] when, string[] valueType = null) {
        if (isEmpty(when)) {
            throw new DInvalidArgumentException("The ` when` argument must be a non-empty array");
        }
        if (
            valueType !is null &&
            !isArray(valueType)
        ) {
            throw new DInvalidArgumentException(
                "When using an array for the ` when` argument, the `type` argument must be an " ~
                "array too, `%s` given.".format(get_debug_type(valueType)
            ));
        }
        // avoid dirtying the type map for possible consecutive `when()` calls
        typeMap = _typeMap.clone;
        if (
            isArray(valueType) &&
            count(valueType) > 0
        ) {
            typeMap = typeMap.setTypes(valueType);
        }
        when = new DQueryExpression(when, typeMap);
    }
    void when(/* object */ float|bool when, string[] valueType = null) {
        else {
            if (
                valueType !is null &&
                !isString(type)
           ) {
                throw new DInvalidArgumentException(
                    "When using a non-array value for the ` when` argument, the `type` argument must " ~
                    "be a string, `%s` given.".format(get_debug_type(type))
               );
            }
            if (
                valueType.isNull &&
                !(cast(IExpression) when)
           ) {
                valueType = this.inferType(when);
            }
        }
        _when = when;
        _whenType = valueType;
    }
    
    // Sets the `THEN` result value.
    void then(Json resultValue, string resultValue = null) {
        if (
            resultValue !is null &&
            !isScalar(resultValue) &&
            !(isObject(resultValue) && !(cast(DClosure)resultValue))
       ) {
            throw new DInvalidArgumentException(
                "The `result` argument must be either `null`, a scalar value, an object, " ~
                "or an instance of `\%s`, `%s` given."
                .format(IExpression.classname, get_debug_type(resultValue)
           ));
        }
        _then = result;
        _thenType = resultValue ? resultValue : this.inferType(resultValue);
        _hasThenBeenDefined = true;
    }
    
    // Returns the expression`s result value type.
    string getResultType() {
        return _thenType;
    }
    
    /**
     * Returns the available data for the given clause.
     *
     * ### Available clauses
     *
     * The following clause names are available:
     *
     * * `when`: The `WHEN` value.
     * * `then`: The `THEN` result value.
     * Params:
     * string aclause The name of the clause to obtain.
     */
    IExpression|object|scalar|null clause(string aclause) {
        if (!isIn(clause, _validClauseNames, true)) {
            throw new DInvalidArgumentException(               
                "The `clause` argument must be one of `%s`, the given value `%s` is invalid."
                .format(join("`, `", _validClauseNames), clause)
           );
        }
        return _{clause};
    }
 
    string sql(DValueBinder aBinder) {
        if (this.when.isNull) {
            throw new DLogicException("Case expression has incomplete when clause. Missing `when()`.");
        }
        if (!this.hasThenBeenDefined) {
            throw new DLogicException("Case expression has incomplete when clause. Missing `then()` after `when()`.");
        }
         when = this.when;
        if (
            isString(this.whenType) &&
            !(cast(IExpression) when)
       ) {
             when = _castToExpression(when, this.whenType);
        }
        if (cast(Query) when) {
             when = "(%s)".format(when.sql(aBinder));
        } else if (cast(IExpression) when) {
             when = when.sql(aBinder);
        } else {
            placeholder = aBinder.placeholder("c");
             whenType = this.whenType.isString
                ? this.whenType 
                : null;
            }
            aBinder.bind(placeholder,  when,  whenType);
             when = placeholder;
        }
        then = this.compileNullableValue(aBinder, this.then, this.thenType);

        return "WHEN  when THEN then";
    }
 
    void traverse(Closure aCallback) {
        if (auto expression = cast(IExpression)_when) {
            aCallback(expression);
            this.when.traverse(aCallback);
        }
        if (auto expression = cast(IExpression)_then) {
            aCallback(expression);
            this.then.traverse(aCallback);
        }
    }

    // Clones the inner expression objects.
    void clone() {
        if (cast(IExpression)_when) {
            this.when = this.clone.when;
        }
        if (cast(IExpression)this.then) {
            this.then = this.clone.then;
        }
    } */
}
mixin(ExpressionCalls!("WhenThen"));
