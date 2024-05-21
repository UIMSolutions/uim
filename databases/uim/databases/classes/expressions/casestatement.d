module uim.databases.classes.expressions.casestatement;

import uim.databases;

@safe:

// Represents a SQL case statement with a fluid API
class DCaseStatementExpression : DExpression { // }, ITypedResult {
    mixin(ExpressionThis!("CaseStatement"));

    mixin TCaseExpression;
    mixin TExpressionTypeCaster;
    mixin TTypeMap;

    // The names of the clauses that are valid for use with the `clause()` method.
    protected string[] validClauseNames = [
        "value",
        "when",
        "else",
    ];

    // Whether this is a simple case expression.
    protected bool isSimpleVariant = false;

    /**
     * The case value.
     *
     * @var \UIM\Database\IExpression|object|scalar|null
     */
    protected Json aValue = null;

    /**
     * The case value type.
     */
    protected string avalueType = null;

    // The `WHEN ... THEN ...` expressions.
    protected DWhenThenExpression[]  when = null;

    /**
     * Buffer that holds values and types for use with `then()`.
     *
     * @var array|null
     */
    protected Json[string] whenBuffer = null;

    /**
     * The else part result value.
     *
     * @var \UIM\Database\IExpression|object|scalar|null
     */
    protected Json else = null;

    /**
     * The else part result type.
     */
    protected string aelseType = null;

    /**
     * The return type.
     */
    protected string resultType = null;

    /**
     * When a value is set, the syntax generated is
     * `CASE case_value WHEN when_value ... END` (simple case),
     * where the `when_value``s are compared against the
     * `case_value`.
     *
     * When no value is set, the syntax generated is
     * `CASE WHEN when_conditions ... END` (searched case),
     * where the conditions hold the comparisons.
     *
     * Note that `null` is a valid case value, and thus should
     * only be passed if you actually want to create the simple
     * case expression variant!
     */
    this(Json caseValue = null, string valueType = null) {
        if (func_num_args() > 0) {
            if (
                aValue !isNull &&
                !isScalar(aValue) &&
                !(isObject(aValue) && !(cast(DClosure)aValue))
            ) {
                throw new DInvalidArgumentException(
                    "The `aValue` argument must be either `null`, a scalar value, an object, " .
                    "or an instance of `\%s`, `%s` given."
                    .format(IExpression.classname,
                    get_debug_type(aValue)
                ));
            }
            _value = aValue;

            if (
                !aValue.isNull &&
                type.isNull &&
                !(cast(IExpression)aValue )
            ) {
                type = this.inferType(aValue);
            }
            _valueType = type;

            _isSimpleVariant = true;
        }
    }
    
    /**
     * Sets the `WHEN` value for a `WHEN ... THEN ...` expression, or a
     * self-contained expression that holds both the value for `WHEN`
     * and the value for `THEN`.
     *
     * ### DOrder based syntax
     *
     * When passing a value other than a self-contained
     * `\UIM\Database\Expression\WhenThenExpression`,
     * instance, the `WHEN ... THEN ...` statement must be closed off with
     * a call to `then()` before invoking `when()` again or `else()`:
     *
     * ```
     * aQueryExpression
     *   .case(aQuery.identifier("Table.column"))
     *   .when(true)
     *   .then("Yes")
     *   .when(false)
     *   .then("No")
     *   .else("Maybe");
     * ```
     *
     * ### Self-contained expressions
     *
     * When passing an instance of `\UIM\Database\Expression\WhenThenExpression`,
     * being it directly, or via a callable, then there is no need to close
     * using `then()` on this object, instead the statement will be closed
     * on the `\UIM\Database\Expression\WhenThenExpression`
     * object using
     * `\UIM\Database\Expression\WhenThenExpression.then()`.
     *
     * Callables will receive an instance of `\UIM\Database\Expression\WhenThenExpression`,
     * and must return one, being it the same object, or a custom one:
     *
     * ```
     * aQueryExpression
     *   .case()
     *   .when(function (\UIM\Database\Expression\WhenThenExpression  whenThen) {
     *       return whenThen
     *           .when(["Table.column": true.toJson])
     *           .then("Yes");
     *   })
     *   .when(function (\UIM\Database\Expression\WhenThenExpression  whenThen) {
     *       return whenThen
     *           .when(["Table.column": false.toJson])
     *           .then("No");
     *   })
     *   .else("Maybe");
     * ```
     *
     * ### Type handling
     *
     * The types provided via the `type` argument will be merged with the
     * type map set for this expression. When using callables for ` when`,
     * the `\UIM\Database\Expression\WhenThenExpression`
     * instance received by the callables will inherit that type map, however
     * the types passed here will _not_be merged in case of using callables,
     * instead the types must be passed in
     * `\UIM\Database\Expression\WhenThenExpression.when()`:
     *
     * ```
     * aQueryExpression
     *   .case()
     *   .when(function (\UIM\Database\Expression\WhenThenExpression  whenThen) {
     *       return whenThen
     *           .when(["unmapped_column": true.toJson], ["unmapped_column": 'bool"])
     *           .then("Yes");
     *   })
     *   .when(function (\UIM\Database\Expression\WhenThenExpression  whenThen) {
     *       return whenThen
     *           .when(["unmapped_column": false.toJson], ["unmapped_column": 'bool"])
     *           .then("No");
     *   })
     *   .else("Maybe");
     * ```
     *
     * ### User data safety
     *
     * When passing user data, be aware that allowing a user defined array
     * to be passed, is a potential SQL injection vulnerability, as it
     * allows for raw SQL to slip in!
     *
     * The following is _unsafe_usage that must be avoided:
     *
     * ```
     * case
     *    .when(userData)
     * ```
     *
     * A safe variant for the above would be to define a single type for
     * the value:
     *
     * ```
     * case
     *    .when(userData, "integer")
     * ```
     *
     * This way an exception would be triggered when an array is passed for
     * the value, thus preventing raw SQL from slipping in, and all other
     * types of values would be forced to be bound as an integer.
     *
     * Another way to safely pass user data is when using a conditions
     * array, and passing user data only on the value side of the array
     * entries, which will cause them to be bound:
     *
     * ```
     * case
     *    .when([
     *        'Table.column": userData,
     *    ])
     * ```
     *
     * Lastly, data can also be bound manually:
     *
     * ```
     * aQuery
     *    .select([
     *        'val": aQuery.newExpr()
     *            .case()
     *            .when(aQuery.newExpr(": userData"))
     *            .then(123)
     *    ])
     *    .bind(": userData", userData, "integer")
     * ```
     * Params:
     * \UIM\Database\IExpression|\Closure|object|array|scalar  when The `WHEN` value. When using an
     * Json[string] of conditions, it must be compatible with `\UIM\Database\Query.where()`. Note that this argument is
     * _not_completely safe for use with user data, as a user supplied array would allow for raw SQL to slip in!If
     * you plan to use user data, either pass a single type for the `type` argument (which forces the ` when` value to
     * be a non-array, and then always binds the data), use a conditions array where the user data is only passed on
     * the value side of the array entries, or custom bindings!
     */
    void when(Json when, string[] whenValueType = null) {
        if (!_whenBuffer.isNull) {
            throw new DLogicException("Cannot call `when()` between `when()` and `then()`.");
        }
        if (cast(DClosure) when) {
             when = when(new WhenThenExpression(getTypeMap()));
            if (!(cast(WhenThenExpression) when )) {
                throw new DLogicException(
                    "`when()` callables must return an instance of `\%s`, `%s` given."
                    .format(WhenThenExpression.classname, get_debug_type(when))
                );
            }
        }
        if (cast(WhenThenExpression) when) {
            _when ~= when;
        } else {
            _whenBuffer = ["when": when, "type": whenValueType];
        }
    }

    /**
     * Sets the `THEN` result value for the last `WHEN ... THEN ...`
     * statement that was opened using `when()`.
     *
     * ### DOrder based syntax
     *
     * This method can only be invoked in case `when()` was previously
     * used with a value other than a closure or an instance of
     * `\UIM\Database\Expression\WhenThenExpression`:
     *
     * ```
     * case
     *   .when(["Table.column": true.toJson])
     *   .then("Yes")
     *   .when(["Table.column": false.toJson])
     *   .then("No")
     *   .else("Maybe");
     * ```
     *
     * The following would all fail with an exception:
     *
     * ```
     * case
     *   .when(["Table.column": true.toJson])
     *   .when(["Table.column": false.toJson])
     *   // ...
     * ```
     *
     * ```
     * case
     *   .when(["Table.column": true.toJson])
     *   .else("Maybe")
     *   // ...
     * ```
     *
     * ```
     * case
     *   .then("Yes")
     *   // ...
     * ```
     *
     * ```
     * case
     *   .when(["Table.column": true.toJson])
     *   .then("Yes")
     *   .then("No")
     *   // ...
     * ```
     */
    void then(Json resultValue, string resultType = null) {
        if (_whenBuffer.isNull) {
            throw new DLogicException("Cannot call `then()` before `when()`.");
        }
         whenThen = (new WhenThenExpression(getTypeMap()))
            .when(_whenBuffer["when"], _whenBuffer["type"])
            .then(resultValue, resultType);

        _whenBuffer = null;

        _when ~= whenThen;
    }
    
    /**
     * Sets the `ELSE` result value.
     * Params:
     * \UIM\Database\|object|scalar|null result The result value.
     */
    void else(/* IExpression */ Json resultValue, string resultType = null) {
        if (!_whenBuffer.isNull) {
            throw new DLogicException("Cannot call `else()` between `when()` and `then()`.");
        }
        if (
            !resultValue.isNull &&
            !isScalar(resultValue) &&
            !(isObject(resultValue) && !(cast(DClosure)resultValue))
        ) {
            throw new DInvalidArgumentException(
                "The `result` argument must be either `null`, a scalar value, an object, " .
                "or an instance of `\%s`, `%s` given."
                .format(IExpression.classname,
                get_debug_type(resultValue)
            ));
        }
        resultType ??= this.inferType(resultValue);

        _else = resultValue;
        _elseType = resultType;
    }
    
    /**
     * Returns the abstract type that this expression will return.
     *
     * If no type has been explicitly set via `setReturnType()`, this
     * method will try to obtain the type from the result types of the
     * `then()` and `else() `calls. All types must be identical in order
     * for this to work, otherwise the type will default to `string`.
     */
    string getReturnType() {
        if (!this.returnType.isNull) {
            return _returnType;
        }
        
        auto types = null;
        _when.each!((w) {
            auto type = w.getResultType();
            if (!type.isNull) {
                types ~= type;
            }
        });
        if (_elseType.isNull) {
            types ~= _elseType;
        }
        types = array_unique(types);
        
        return count(types) == 1
            ? types[0]
            : "string";
    }
    
    /**
     * Sets the abstract type that this expression will return.
     *
     * If no type is being explicitly set via this method, then the
     * `getReturnType()` method will try to infer the type from the
     * result types of the `then()` and `else() `calls.
     */
    void setReturnType(string typeName) {
        this.returnType = typeName;
    }
    
    /**
     * Returns the available data for the given clause.
     *
     * ### Available clauses
     *
     * The following clause names are available:
     *
     * * `value`: The case value for a `CASE case_value WHEN ...` expression.
     * * `when`: An array of `WHEN ... THEN ...` expressions.
     * * `else`: The `ELSE` result value.
     */
    IExpression|object|array<\UIM\Database\Expression\WhenThenExpression>|scalar|null clause(string clauseName) {
        if (!in_array(clauseName, this.validClauseNames, true)) {
            throw new DInvalidArgumentException(
                "The `clause` argument must be one of `%s`, the given value `%s` is invalid."
                    .format(this.validClauseNames.join("`, `"), clauseName)
            );
        }
        return _{clauseName};
    }
 
    string sql(DValueBinder aBinder) {
        if (!_whenBuffer.isNull) {
            throw new DLogicException("Case expression has incomplete when clause. Missing `then()` after `when()`.");
        }
        if (_when.isEmpty) {
            throw new DLogicException("Case expression must have at least one when statement.");
        }
        
        string aValue = "";
        if (this.isSimpleVariant) {
            aValue = this.compileNullableValue(aBinder, _value, _valueType) ~ " ";
        }
        
        auto whenThenExpressions = _when
            .map!(whenThen => whenThenExpressions ~= whenThen.sql(aBinder))
            .array;        
        string whenThen = whenThenExpressions.join(" ");
        
        auto sqlElse = this.compileNullableValue(aBinder, _else, _elseType);
        return "CASE {aValue}{ whenThen} ELSE else END";
    }
 
    void traverse(Closure aCallback) {
        if (_whenBuffer !isNull) {
            throw new DLogicException("Case expression has incomplete when clause. Missing `then()` after `when()`.");
        }
        
        if (cast(IExpression)_value ) {
            aCallback(_value);
            _value.traverse(aCallback);
        }
        _when.each!(when => {
            aCallback(when);
            when.traverse(aCallback);
        });

        if (cast(IExpression)_else ) {
            aCallback(_else);
            _else.traverse(aCallback);
        }
    }
    
    // Clones the inner expression objects.
    void clone() {
        if (whenBuffer) {
            throw new DLogicException("Case expression has incomplete when clause. Missing `then()` after `when()`.");
        }
        if (cast(IExpression)_value ) {
            _value = clone _value;
        }
        foreach (_when as aKey:  when) {
            _when[aKey] = clone _when[aKey];
        }
        if (cast(IExpression)_else ) {
            _else = clone _else;
        }
    } 
}
mixin(ExpressionCalls!("CaseStatement"));
