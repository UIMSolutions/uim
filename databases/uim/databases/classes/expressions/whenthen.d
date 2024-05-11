module uim.databases.classes.expressions.whenthen;

import uim.databases;

@safe:

/**
 * Represents a SQL when/then clause with a fluid API
 */
class DWhenThenExpression : DExpression {
    mixin(ExpressionThis!("WhenThen"));

    /*
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
    protected Json  when = null;

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

    /**
     * Constructor.
     * Params:
     * \UIM\Database\TypeMap|null typeMap The type map to use when using an array of conditions for the `WHEN`
     * value.
     */
    this(TypeMap typeMap = null) {
       _typeMap = typeMap ?? new DTypeMap();
    }
    
    /**
     * Sets the `WHEN` value.
     * Params:
     * object|string[]|float|bool  when The `WHEN` value. When using an array of
     * conditions, it must be compatible with `\UIM\Database\Query.where()`. Note that this argument is _not_
     * completely safe for use with user data, as a user supplied array would allow for raw SQL to slip in!If you
     * plan to use user data, either pass a single type for the `type` argument (which forces the ` when` value to be
     * a non-array, and then always binds the data), use a conditions array where the user data is only passed on the
     * value side of the array entries, or custom bindings!
     * @param STRINGAA|string|null type The when value type. Either an associative array when using array style
     * conditions, or else a string. If no type is provided, the type will be tried to be inferred from the value.

     * @throws \InvalidArgumentException In case the ` when` argument is an empty array.
     * @throws \InvalidArgumentException In case the ` when` argument is an array, and the `type` argument is neither
     * an array, nor null.
     * @throws \InvalidArgumentException In case the ` when` argument is a non-array value, and the `type` argument is
     * neither a string, nor null.
     */
    void when(object|string[]|float|bool  when, string[] type = null) {
        if (isArray(when)) {
            if (isEmpty(when)) {
                throw new DInvalidArgumentException("The ` when` argument must be a non-empty array");
            }
            if (
                type !isNull &&
                !isArray(type)
            ) {
                throw new DInvalidArgumentException(
                    "When using an array for the ` when` argument, the `type` argument must be an " ~
                    "array too, `%s` given.".format(get_debug_type(type)
                ));
            }
            // avoid dirtying the type map for possible consecutive `when()` calls
            typeMap = clone _typeMap;
            if (
                isArray(type) &&
                count(type) > 0
            ) {
                typeMap = typeMap.setTypes(type);
            }
             when = new DQueryExpression(when, typeMap);
        } else {
            if (
                type !isNull &&
                !isString(type)
            ) {
                throw new DInvalidArgumentException(
                    "When using a non-array value for the ` when` argument, the `type` argument must " ~
                    "be a string, `%s` given.".format(get_debug_type(type))
                );
            }
            if (
                type.isNull &&
                !(cast(IExpression) when )
            ) {
                type = this.inferType(when);
            }
        }
        this.when = when;
        this.whenType = type;
    }
    
    /**
     * Sets the `THEN` result value.
     * Params:
     * \UIM\Database\IExpression|object|scalar|null result The result value.
     * @param string|null type The result type. If no type is provided, the type will be inferred from the given
     * result value.
     */
    void then(Json result, string atype = null) {
        if (
            result !isNull &&
            !isScalar(result) &&
            !(isObject(result) && !(cast(DClosure)result))
        ) {
            throw new DInvalidArgumentException(
                "The `result` argument must be either `null`, a scalar value, an object, " ~
                "or an instance of `\%s`, `%s` given."
                .format(IExpression.classname,
                get_debug_type(result)
            ));
        }
        this.then = result;

        this.thenType = type ?? this.inferType(result);

        this.hasThenBeenDefined = true;
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
        if (!in_array(clause, _validClauseNames, true)) {
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
            !(cast(IExpression) when )
        ) {
             when = _castToExpression(when, this.whenType);
        }
        if (cast(Query) when ) {
             when = "(%s)".format(when.sql(aBinder));
        } elseif (cast(IExpression) when ) {
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
        if (auto expression = cast(IExpression)_when ) {
            aCallback(expression);
            this.when.traverse(aCallback);
        }
        if (auto expression = cast(IExpression)_then ) {
            aCallback(expression);
            this.then.traverse(aCallback);
        }
    }

    // Clones the inner expression objects.
    void clone() {
        if (cast(IExpression)_when ) {
            this.when = clone this.when;
        }
        if (cast(IExpression)this.then ) {
            this.then = clone this.then;
        }
    } */
}
mixin(ExpressionCalls!("WhenThen"));
