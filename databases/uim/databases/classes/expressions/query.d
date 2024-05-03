module uim.databases.classes.expressions.query;

import uim.databases;

@safe:

/**
 * Represents a SQL Query expression. Internally it stores a tree of
 * expressions that can be compiled by converting this object to string
 * and will contain a correctly parenthesized and nested expression.
 */
class DQueryExpression : DExpression { // }, Countable {
    mixin(ExpressionThis!("Query"));

    /* mixin TTypeMap;

    /**
     * String to be used for joining each of the internal expressions
     * this object internally stores for example "AND", "OR", etc.
     */
    protected string _conjunction;

    /**
     * A list of strings or other expression objects that represent the "branches" of
     * the expression tree. For example one key of the array might look like "sum > :value"
     * /
    // TODO protected array _conditions = null;

    /**
     * Constructor. A new expression object can be created without any params and
     * be built dynamically. Otherwise, it is possible to pass an array of conditions
     * containing either a tree-like array structure to be parsed and/or other
     * expression objects. Optionally, you can set the conjunction keyword to be used
     * for joining each part of this level of the expression tree.
     * Params:
     * \UIM\Database\IExpression|string[] aconditions Tree like array structure
     * containing all the conditions to be added or nested inside this expression object.
     * @param \UIM\Database\TypeMap|array types Associative array of types to be associated with the values
     * passed in conditions.
     * @param string aconjunction the glue that will join all the string conditions at this
     * level of the expression tree. For example "AND", "OR", "XOR"...
     * @see \UIM\Database\Expression\QueryExpression.add() for more details on conditions and types
     * /
    this(
        IExpression|string[] aconditions = [],
        TypeMap|array types = [],
        string aconjunction = "AND"
    ) {
        this.setTypeMap(types);
        this.setConjunction(strtoupper(conjunction));
        if (!conditions.isEmpty) {
            this.add(conditions, this.getTypeMap().getTypes());
        }
    }
    
    // Changes the conjunction for the conditions at this level of the expression tree.
    void setConjunction(string valueForJoiningConditions) {
       _conjunction = valueForJoiningConditions.toUpper;
    }

    // Gets the currently configured conjunction for the conditions at this level of the expression tree.
    string getConjunction() {
        return _conjunction;
    }
    
    /**
     * Adds one or more conditions to this expression object. Conditions can be
     * expressed in a one dimensional array, that will cause all conditions to
     * be added directly at this level of the tree or they can be nested arbitrarily
     * making it create more expression objects that will be nested inside and
     * configured to use the specified conjunction.
     *
     * If the type passed for any of the fields is expressed "type[]" (note braces)
     * then it will cause the placeholder to be re-written dynamically so if the
     * value is an array, it will create as many placeholders as values are in it.
     * Params:
     * \UIM\Database\IExpression|string[] aconditions single or multiple conditions to
     * be added. When using an array and the key is 'OR' or 'AND' a new expression
     * object will be created with that conjunction and internal array value passed
     * as conditions.
     * @param array<int|string, string> types Associative array of fields pointing to the type of the
     * values that are being passed. Used for correctly binding values to statements.
     * @see \UIM\Database\Query.where() for examples on conditions
     * /
    void add(IExpression|string[] aconditions, array types = []) {
        if (isString(conditions) || cast(IExpression)conditions ) {
           _conditions ~= conditions;

            return;
        }
       _addConditions(conditions, types);
    }

    /**
     * Adds a new condition to the expression object in the form "field = value".
     * Params:
     * \UIM\Database\IExpression|string afield Database field to be compared against value
     * @param Json aValue The value to be bound to field for comparison
     * If it is suffixed with "[]" and the value is an array then multiple placeholders
     * will be created, one per each value in the array.
     * /
    auto eq(IExpression|string afield, Json aValue, string typeName = null) {
        typeName = typeName.ifEmpty(_calculateType(field));

        return _add(new DComparisonExpression(field, aValue, typeName, "="));
    }

    /**
     * Adds a new condition to the expression object in the form "field != value".
     * Params:
     * \UIM\Database\IExpression|string afield Database field to be compared against value
     * @param Json aValue The value to be bound to field for comparison
     * @param string|null type the type name for aValue as configured using the Type map.
     * If it is suffixed with "[]" and the value is an array then multiple placeholders
     * will be created, one per each value in the array.
     * /
    auto notEq(IExpression|string afield, Json aValue, string atype = null) {
        auto type ??= _calculateType(field);

        return _add(new DComparisonExpression(field, aValue, type, "!="));
    }
    
    /**
     * Adds a new condition to the expression object in the form "field > value".
     * Params:
     * \UIM\Database\IExpression|string afield Database field to be compared against value
     * @param Json aValue The value to be bound to field for comparison
     * @param string|null type the type name for aValue as configured using the Type map.
     * /
    auto gt(IExpression|string afield, Json aValue, string atype = null) {
        auto type ??= _calculateType(field);

        return _add(new DComparisonExpression(field, aValue, type, ">"));
    }
    
    /**
     * Adds a new condition to the expression object in the form "field < value".
     * Params:
     * \UIM\Database\IExpression|string afield Database field to be compared against value
     * @param Json aValue The value to be bound to field for comparison
     * @param string|null type the type name for aValue as configured using the Type map.
     * /
    auto lt(IExpression|string afield, Json aValue, string atype = null) {
        type ??= _calculateType(field);

        return _add(new DComparisonExpression(field, aValue, type, "<"));
    }
    
    /**
     * Adds a new condition to the expression object in the form "field >= value".
     * Params:
     * \UIM\Database\IExpression|string afield Database field to be compared against value
     * @param Json aValue The value to be bound to field for comparison
     * @param string|null type the type name for aValue as configured using the Type map.
     * /
    auto gte(IExpression|string afield, Json aValue, string atype = null) {
        type ??= _calculateType(field);

        return _add(new DComparisonExpression(field, aValue, type, ">="));
    }
    
    /**
     * Adds a new condition to the expression object in the form "field <= value".
     * Params:
     * \UIM\Database\IExpression|string afield Database field to be compared against value
     * @param Json aValue The value to be bound to field for comparison
     * @param string|null type the type name for aValue as configured using the Type map.
     * /
    auto lte(IExpression|string afield, Json aValue, string atype = null) {
        type ??= _calculateType(field);

        return _add(new DComparisonExpression(field, aValue, type, "<="));
    }
    
    /**
     * Adds a new condition to the expression object in the form "field isNull".
     * Params:
     * \UIM\Database\IExpression|string afield database field to be
     * tested for null
     * /
    auto isNull(IExpression|string afield) {
        if (!(cast(IExpression)field )) {
            field = new DIdentifierExpression(field);
        }
        return _add(new DUnaryExpression("isNull", field, UnaryExpression.POSTFIX));
    }
    
    /**
     * Adds a new condition to the expression object in the form "field IS NOT NULL".
     * Params:
     * \UIM\Database\IExpression|string afield database field to be tested for not null
     * /
    auto isNotNull(IExpression|string afield) {
        if (!(cast(IExpression)field)) {
            field = new DIdentifierExpression(field);
        }
        return _add(new DUnaryExpression("IS NOT NULL", field, UnaryExpression.POSTFIX));
    }
    
    /**
     * Adds a new condition to the expression object in the form "field LIKE value".
     * Params:
     * \UIM\Database\IExpression|string afield Database field to be compared against value
     * @param Json aValue The value to be bound to field for comparison
     * @param string|null type the type name for aValue as configured using the Type map.
     * /
    auto like(IExpression|string afield, Json aValue, string atype = null) {
        type ??= _calculateType(field);

        return _add(new DComparisonExpression(field, aValue, type, "LIKE"));
    }
    
    /**
     * Adds a new condition to the expression object in the form "field NOT LIKE value".
     * Params:
     * \UIM\Database\IExpression|string afield Database field to be compared against value
     * @param Json aValue The value to be bound to field for comparison
     * @param string|null type the type name for aValue as configured using the Type map.
     * /
    auto notLike(IExpression|string afield, Json aValue, string atype = null) {
        type ??= _calculateType(field);

        return _add(new DComparisonExpression(field, aValue, type, "NOT LIKE"));
    }
    
    /**
     * Adds a new condition to the expression object in the form
     * "field IN (value1, value2)".
     * Params:
     * \UIM\Database\IExpression|string afield Database field to be compared against value
     * @param \UIM\Database\IExpression|string[] avalues the value to be bound to field for comparison
     * @param string|null type the type name for aValue as configured using the Type map.
     * /
    auto in(
        IExpression|string afield,
        IExpression|string[] avalues,
        string atype = null
    ) {
        type ??= _calculateType(field);
        type = type ?: "string";
        type ~= "[]";
         someValues = cast(IExpression)someValues  ?  someValues : (array) someValues;

        return _add(new DComparisonExpression(field,  someValues, type, "IN"));
    }
    
    /**
     * Returns a new case expression object.
     *
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
     * Params:
     * \UIM\Database\IExpression|object|scalar|null aValue The case value.
     * @param string|null type The case value type. If no type is provided, the type will be tried to be inferred
     * from the value.
     * /
    CaseStatementExpression case(Json aValue = null, string atype = null) {
        auto caseExpression = (func_num_args() > 0) 
            ? new DCaseStatementExpression(aValue, type);
            : new DCaseStatementExpression();
        
        return caseExpression.setTypeMap(this.getTypeMap());
    }
    
    /**
     * Adds a new condition to the expression object in the form
     * "field NOT IN (value1, value2)".
     * Params:
     * \UIM\Database\IExpression|string afield Database field to be compared against value
     * @param \UIM\Database\IExpression|string[] avalues the value to be bound to field for comparison
     * @param string|null type the type name for aValue as configured using the Type map.
     * /
    auto notIn(
        IExpression|string afield,
        IExpression|string[] avalues,
        string atype = null
    ) {
        type ??= _calculateType(field);
        type = type ?: "string";
        type ~= "[]";
         someValues = cast(IExpression)someValues  ?  someValues : (array) someValues;

        return _add(new DComparisonExpression(field,  someValues, type, "NOT IN"));
    }
    
    /**
     * Adds a new condition to the expression object in the form
     * "(field NOT IN (value1, value2) OR field isNull".
     * Params:
     * \UIM\Database\IExpression|string afield Database field to be compared against value
     * @param \UIM\Database\IExpression|string[] avalues the value to be bound to field for comparison
     * @param string|null type the type name for aValue as configured using the Type map.
     * /
    auto notInOrNull(
        IExpression|string afield,
        IExpression|string[] avalues,
        string atype = null
    ) {
         or = new static([], [], "OR");
         or
            .notIn(field,  someValues, type)
            .isNull(field);

        return _add(or);
    }
    
    /**
     * Adds a new condition to the expression object in the form "EXISTS (...)".
     * Params:
     * \UIM\Database\IExpression expression the inner query
     * /
    auto exists(IExpression expression) {
        return _add(new DUnaryExpression("EXISTS", expression, UnaryExpression.PREFIX));
    }
    
    /**
     * Adds a new condition to the expression object in the form "NOT EXISTS (...)".
     * Params:
     * \UIM\Database\IExpression expression the inner query
     * /
    auto notExists(IExpression expression) {
        return _add(new DUnaryExpression("NOT EXISTS", expression, UnaryExpression.PREFIX));
    }
    
    /**
     * Adds a new condition to the expression object in the form
     * "field BETWEEN from AND to".
     * Params:
     * \UIM\Database\IExpression|string afield The field name to compare for values inbetween the range.
     * @param Json from The initial value of the range.
     * @param Json to The ending value in the comparison range.
     * @param string|null type the type name for aValue as configured using the Type map.
     * /
    auto between(IExpression|string afield, Json from, Json to, string atype = null) {
        type ??= _calculateType(field);

        return _add(new BetweenExpression(field, from, to, type));
    }
    
    /**
     * Returns a new QueryExpression object containing all the conditions passed
     * and set up the conjunction to be "AND"
     * Params:
     * \UIM\Database\IExpression|\Closure|string[] aconditions to be joined with AND
     * passedTypes Associative array of fields pointing to the type of the
     * values that are being passed. Used for correctly binding values to statements.
     * /
    static and(IExpression|Closure|string[] aconditions, STRINGAA passedTypes = null) {
        if (cast(DClosure)conditions) {
            return conditions(new static([], this.getTypeMap().setTypes(passedTypes)));
        }
        return new static(conditions, this.getTypeMap().setTypes(passedTypes));
    }
    
    /**
     * Returns a new QueryExpression object containing all the conditions passed
     * and set up the conjunction to be "OR"
     * Params:
     * \UIM\Database\IExpression|\Closure|string[] aconditions to be joined with OR
     * passedTypes Associative array of fields pointing to the type of the
     * values that are being passed. Used for correctly binding values to statements.
     * /
    static or(IExpression|Closure|string[] aconditions, STRINGAA passedTypes = []) {
        if (cast(DClosure)conditions) {
            return conditions(new static([], this.getTypeMap().setTypes(passedTypes), "OR"));
        }
        return new static(conditions, this.getTypeMap().setTypes(passedTypes), "OR");
    }
    
    /**
     * Adds a new set of conditions to this level of the tree and negates
     * the final result by prepending a NOT, it will look like
     * "NOT ((condition1) AND (conditions2) )" conjunction depends on the one
     * currently configured for this object.
     * Params:
     * \UIM\Database\IExpression|\Closure|string[] aconditions to be added and negated
     * passedTypes Associative array of fields pointing to the type of the
     * values that are being passed. Used for correctly binding values to statements.
     * /
    auto not(IExpression|Closure|string[] aconditions, STRINGAA passedTypes = []) {
        return _add(["NOT": conditions], passedTypes);
    }
    
    /**
     * Returns the number of internal conditions that are stored in this expression.
     * Useful to determine if this expression object is void or it will generate
     * a non-empty string when compiled
     * /
    size_t count() {
        return count(_conditions);
    }
    
    /**
     * Builds equal condition or assignment with identifier wrapping.
     * Params:
     * string aleftField Left join condition field name.
     * @param string arightField Right join condition field name.
     * /
    auto equalFields(string aleftField, string arightField) {
         wrapIdentifier = auto (field) {
            if (cast(IExpression)field ) {
                return field;
            }
            return new DIdentifierExpression(field);
        };

        return _eq(wrapIdentifier(leftField),  wrapIdentifier(rightField));
    }
    string sql(DValueBinder aBinder) {
         len = this.count();
        if (len == 0) {
            return "";
        }
        conjunction = _conjunction;
        template = len == 1 ? "%s' : '(%s)";
        someParts = null;
        foreach (_conditions as part) {
            if (cast(Query)part) {
                part = "(" ~ part.sql(aBinder) ~ ")";
            } elseif (cast(IExpression)part) {
                part = part.sql(aBinder);
            }
            if (part != "") {
                someParts ~= part;
            }
        }
        return template.format(join(" conjunction ", someParts));
    }

    void traverse(Closure aCallback) {
        _conditions.each!((condition) {
            if (cast(IExpression)c ) {
                aCallback(condition);
                condition.traverse(aCallback);
            }
        });
    }
    
    /**
     * Executes a callback for each of the parts that form this expression.
     *
     * The callback is required to return a value with which the currently
     * visited part will be replaced. If the callback returns null then
     * the part will be discarded completely from this expression.
     *
     * The callback auto will receive each of the conditions as first param and
     * the key as second param. It is possible to declare the second parameter as
     * passed by reference, this will enable you to change the key under which the
     * modified part is stored.
     * Params:
     * \Closure aCallback The callback to run for each part
     * /
    void iterateParts(Closure aCallback) {
        someParts = null;
        foreach (myKey: c; _conditions) {
            aKey = &myKey;
            part = aCallback(c, aKey);
            if (part !isNull) {
                someParts[aKey] = part;
            }
        }
       _conditions = someParts;
    }
    
    /**
     * Returns true if this expression contains any other nested
     * IExpression objects
     * /
    bool hasNestedExpression() {
        foreach (condition; _conditions) {
            if (cast(IExpression)condition ) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Auxiliary auto used for decomposing a nested array of conditions and build
     * a tree structure inside this object to represent the full SQL expression.
     * String conditions are stored directly in the conditions, while any other
     * representation is wrapped around an adequate instance or of this class.
     * Params:
     * array conditions list of conditions to be stored in this object
     * fieldTypes list of types associated on fields referenced in conditions
     * /
    protected void _addConditions(array conditions, STRINGAA fieldTypes) {
         operators = ["and", "or", "xor"];

        typeMap = this.getTypeMap().setTypes(fieldTypes);

        foreach (myKey: c; conditions) {
            numericKey = isNumeric(myKey);

            if (cast(DClosure)c) {
                expr = new static([], typeMap);
                c = c(expr, this);
            }
            if (numericKey && empty(c)) {
                continue;
            }
             isArray = isArray(c);
             isOperator = isNot = false;
            if (!numericKey) {
                normalizedKey = myKey.toLower;
                 isOperator = in_array(normalizedKey,  operators);
                 isNot = normalizedKey == "not";
            }
            if ((isOperator ||  isNot) && (isArray || cast(DCountable)c) && count(c) == 0) {
                continue;
            }
            if (numericKey && cast(IExpression)c ) {
               _conditions ~= c;
                continue;
            }
            if (numericKey && isString(c)) {
               _conditions ~= c;
                continue;
            }
            if (numericKey &&  isArray ||  isOperator) {
               _conditions ~= new static(c, typeMap, numericKey ? "AND" : myKey);
                continue;
            }
            if (isNot) {
               _conditions ~= new DUnaryExpression("NOT", new static(c, typeMap));
                continue;
            }
            if (!numericKey) {
               _conditions ~= _parseCondition(myKey, c);
            }
        }
    }
    
    /**
     * Parses a string conditions by trying to extract the operator inside it if any
     * and finally returning either an adequate QueryExpression object or a plain
     * string representation of the condition. This bool is responsible for
     * generating the placeholders and replacing the values by them, while storing
     * the value elsewhere for future binding.
     * Params:
     * string acondition The value from which the actual field and operator will
     * be extracted.
     * @param Json aValue The value to be bound to a placeholder for the field
     * /
    protected IExpression|string _parseCondition(string acondition, Json aValue) {
        auto expression = strip(condition);
         operator = "=";

        spaces = substr_count(expression, " ");
        // Handle expression values that contain multiple spaces, such as
        // operators with a space in them like `field IS NOT` and
        // `field NOT LIKE`, or combinations with auto expressions
        // like `CONCAT(first_name, " ", last_name) IN`.
        if (spaces > 1) {
            string[] someParts = expression.split(" ");
            if (preg_match("/(is not|not \w+)$/i", expression)) {
                 last = array_pop(someParts);
                second = array_pop(someParts);
                someParts ~= "{second} { last}";
            }
             operator = array_pop(someParts);
            expression = someParts.join(" ");
        } elseif (spaces == 1) {
            string[] someParts = split(" ", expression, 2);
            [expression,  operator] = someParts;
        }
         operator = strtoupper(trim(operator));

        type = this.getTypeMap().type(expression);
        typeMultiple = (isString(type) && type.has("[]"));
        if (in_array(operator, ["IN", "NOT IN"]) || typeMultiple) {
            type = type ?: "string";
            if (!typeMultiple) {
                type ~= "[]";
            }
             operator = operator == "=" ? "IN" :  operator;
             operator = operator == "!=" ? "NOT IN" :  operator;
            typeMultiple = true;
        }

        if (typeMultiple) {
            aValue = cast(IExpression)aValue  ? aValue : (array)aValue;
        }
        if (operator == "IS' && aValue.isNull) {
            return new DUnaryExpression(
                'isNull",
                new DIdentifierExpression(expression),
                UnaryExpression.POSTFIX
            );
        }
        if (operator == "IS NOT" && aValue.isNull) {
            return new DUnaryExpression(
                "IS NOT NULL",
                new DIdentifierExpression(expression),
                UnaryExpression.POSTFIX
            );
        }
        if (operator == "IS" && aValue !isNull) {
             operator = "=";
        }
        if (operator == "IS NOT" && aValue !isNull) {
             operator = "!=";
        }
        if (aValue.isNull && _conjunction != ",") {
            throw new DInvalidArgumentException(
                "Expression `%s` is missing operator (IS, IS NOT) with `null` value.".format(expression)
            );
        }
        return new DComparisonExpression(expression, aValue, type,  operator);
    }
    
    /**
     * Returns the type name for the passed field if it was stored in the typeMap
     * Params:
     * \UIM\Database\IExpression|string afield The field name to get a type for.
     * /
    protected string _calculateType(IExpression|string afield) {
        field = cast(IdentifierExpression)field ? field.getIdentifier() : field;
        if (!isString(field)) {
            return null;
        }
        return _getTypeMap().type(field);
    }
    
    // Clone this object and its subtree of expressions.
    void clone() {
        foreach (anI: condition; _conditions) {
            if (cast(IExpression)condition ) {
               _conditions[anI] = clone condition;
            }
        }
    } */
}
mixin(ExpressionCalls!("Query"));
