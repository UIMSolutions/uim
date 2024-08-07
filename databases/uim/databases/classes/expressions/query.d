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
     */
    protected Json[string] _conditions = null;

    /**
     . A new expression object can be created without any params and
     * be built dynamically. Otherwise, it is possible to pass an array of conditions
     * containing either a tree-like array structure to be parsed and/or other
     * expression objects. Optionally, you can set the conjunction keyword to be used
     * for joining each part of this level of the expression tree.
     */
    this(
        /* IExpression| */ string[] aconditions = null,
        TypeMap|array types = null,
        string conjunctionType = "AND" // or "OR", "XOR"
   ) {
        setTypeMap(types);
        conjunctionType(conjunctionType.upper);
        if (!conditions.isEmpty) {
            add(conditions, getTypeMap().getTypes());
        }
    }
    
    // Changes the conjunction for the conditions at this level of the expression tree.
    void conjunctionType(string valueForJoiningConditions) {
       _conjunction = valueForJoiningConditions.upper;
    }

    // Gets the currently configured conjunction for the conditions at this level of the expression tree.
    string conjunctionType() {
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
     */
    void add(/* IExpression| */ string[] conditions, Json[string] types = null) {
        if (isString(conditions) || cast(IExpression)conditions) {
           _conditions ~= conditions;

            return;
        }
       _addConditions(conditions, types);
    }

    // Adds a new condition to the expression object in the form "field = value".
    // TODO auto eq(/* IExpression| */ string fieldName, Json valueToDriver, string typeName = null) {
    auto eq(string fieldName, Json valueToDriver, string typeName = null) {
        typeName = typeName.ifEmpty(_calculateType(field));

        return _add(new DComparisonExpression(fieldName, valueToDriver, typeName, "="));
    }

    // Adds a new condition to the expression object in the form "field != value".
    // TODO auto notEq(/* IExpression| */ string fieldName, Json valueToBound, string valueType = null) {
    auto notEq(/* IExpression| */ string fieldName, Json valueToBound, string valueType = null) {
        valueType = valueType.ifEmpty(_calculateType(field));

        return _add(new DComparisonExpression(field, valueToBound, valueType, "!="));
    }
    
    // Adds a new condition to the expression object in the form "field > value".
    auto gt(/* IExpression| */ string fieldName, Json valueToBound, string valueType = null) {
        valueType = valueType.ifEmpty(_calculateType(fieldName));
        return _add(new DComparisonExpression(fieldName, valueToBound, valueType, ">"));
    }
    
    // Adds a new condition to the expression object in the form "field < value".
    auto lt(/* IExpression| */ string fieldName, Json valueToBound, string valueType = null) {
        valueType = valueType.ifEmpty(_calculateType(fieldName));

        return _add(new DComparisonExpression(fieldName, valueToBound, valueType, "<"));
    }
    
    // Adds a new condition to the expression object in the form "field >= value".
    auto gte(/* IExpression| */ string fieldName, Json valueToBound, string valueType = null) {
        valueType = valueType.ifEmpty(_calculateType(fieldName));

        return _add(new DComparisonExpression(fieldName, valueToBound, valueType, ">="));
    }
    
    // Adds a new condition to the expression object in the form "field <= value".
    auto lte(/* IExpression| */ string fieldName, Json valueToBound, string valueType = null) {
        valueType = valueType.ifEmpty(_calculateType(fieldName));

        return _add(new DComparisonExpression(fieldName, valueToBound, valueType, "<="));
    }
    
    /**
     * Adds a new condition to the expression object in the form "field isNull".
     * Params:
     * \UIM\Database\/* IExpression| */ string fieldName database field to be
     * tested for null
     */
    auto isNull(/* IExpression| */ string fieldName) {
        if (!cast(IExpression)field) {
            field = new DIdentifierExpression(field);
        }
        return _add(new DUnaryExpression("isNull", field, UnaryExpression.POSTFIX));
    }
    
    // Adds a new condition to the expression object in the form "field IS NOT NULL".
    auto isNotNull(/* IExpression| */ string fieldName) {
        if (!(cast(IExpression)field)) {
            field = new DIdentifierExpression(field);
        }
        return _add(new DUnaryExpression("IS NOT NULL", field, UnaryExpression.POSTFIX));
    }
    
    //  Adds a new condition to the expression object in the form "field LIKE value".
    auto like(/* IExpression| */ string fieldName, Json valueToBound, string valueType = null) {
        valueType = valueType.ifEmpty(_calculateType(field));

        return _add(new DComparisonExpression(field, valueToBound, valueType, "LIKE"));
    }
    
    // Adds a new condition to the expression object in the form "field NOT LIKE value".
    auto notLike(/* IExpression| */ string fieldName, Json valueToBound, string valueType = null) {
        valueType = valueType.ifEmpty(_calculateType(fieldName));

        return _add(new DComparisonExpression(fieldName, valueToBound, valueType, "NOT LIKE"));
    }
    
    // Adds a new condition to the expression object in the form "field IN (value1, value2)".
    auto in(
        /* IExpression| */ string fieldName,
        /* IExpression| */ string[] boundValues,
        string valueType = null
   ) {
        valueType = valueType.ifEmpty(_calculateType(fieldName)).ifEmpty("string");
        type ~= "[]";
        // boundValues = cast(IExpression)boundValues  ?  boundValues : /* (array) */ boundValues;

        return _add(new DComparisonExpression(fieldName,  boundValues, valueType, "IN"));
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
     */
    DCaseStatementExpression caseExpression(Json caseValue = null, string caseValueType = null) {
        /* auto caseExpression = (func_num_args() > 0) 
            ? new DCaseStatementExpression(caseValue, caseValueType);
            : new DCaseStatementExpression();
        
        return caseExpression.setTypeMap(getTypeMap()); */
        return null; 
    }
    
    /**
     * Adds a new condition to the expression object in the form
     * "field NOT IN (value1, value2)".
     */
    auto notIn(
        /* IExpression */ string fieldName,
        /* IExpression */ string[] valuesToBound,
        string valueType = null
   ) {
        valueType = valueType.ifEmpty(_calculateType(fieldName)).ifEmpty("string");
         someValues = cast(IExpression)valuesToBound  ?  valuesToBound : /* (array) */ valuesToBound;

        return _add(new DComparisonExpression(fieldName,  valuesToBound, valueType, "NOT IN"));
    }
    
    // Adds a new condition to the expression object in the form "(field NOT IN (value1, value2) OR field isNull".
    auto notInOrNull(
        /* IExpression| */ string fieldName,
        /* IExpression| */ string[] valuesToBound,
        string valueType = null
   ) {
         auto or = new static([], [], "OR");
         or
            .notIn(fieldName,  valuesToBound, valueType)
            .isNull(fieldName);

        return _add(or);
    }
    
    /**
     * Adds a new condition to the expression object in the form "EXISTS (...)".
     * Params:
     * \UIM\Database\IExpression expression the inner query
     */
    auto hasKey(IExpression expression) {
        return _add(new DUnaryExpression("EXISTS", expression, UnaryExpression.PREFIX));
    }
    
    //  Adds a new condition to the expression object in the form "NOT EXISTS (...)".
    auto nothasKey(IExpression innerQuery) {
        return _add(new DUnaryExpression("NOT EXISTS", innerQuery, UnaryExpression.PREFIX));
    }
    
    // Adds a new condition to the expression object in the form "field BETWEEN from AND to".
    auto between(/* IExpression| */ string fieldName, Json fromValue, Json toValue, string valueType = null) {
        valueType = valueType.ifEmpty(_calculateType(fieldName));
        return _add(new BetweenExpression(fieldName, fromValue, toValue, valueType));
    }
    
    /**
     * Returns a new QueryExpression object containing all the conditions passed
     * and set up the conjunction to be "AND"
     * Params:
     * \UIM\Database\IExpression|\/*Closure|*/ string[] aconditions to be joined with AND
     * passedTypes Associative array of fields pointing to the type of the
     * values that are being passed. Used for correctly binding values to statements.
     */
    static and(/* IExpression|Closure */string[] conditions, STRINGAA passedTypes = null) {
        return cast(DClosure)conditions
            ? conditions(new static([], getTypeMap().setTypes(passedTypes)))
            : new static(conditions, getTypeMap().setTypes(passedTypes));
    }
    
    /**
     * Returns a new QueryExpression object containing all the conditions passed
     * and set up the conjunction to be "OR"
     * Params:
     * \UIM\Database\IExpression|\/*Closure|* / string[] aconditions to be joined with OR
     * passedTypes Associative array of fields pointing to the type of the
     * values that are being passed. Used for correctly binding values to statements.
     */
    static or(/* IExpression|Closure */string[] conditions, STRINGAA passedTypes = null) {
        if (cast(DClosure)conditions) {
            return conditions(new static([], getTypeMap().setTypes(passedTypes), "OR"));
        }
        return new static(conditions, getTypeMap().setTypes(passedTypes), "OR");
    }
    
    /**
     * Adds a new set of conditions to this level of the tree and negates
     * the final result by prepending a NOT, it will look like
     * "NOT ((condition1) AND (conditions2))" conjunction depends on the one
     * currently configured for this object.
     * Params:
     * \UIM\Database\IExpression|\/*Closure| * / string[] aconditions to be added and negated
     * passedTypes Associative array of fields pointing to the type of the
     * values that are being passed. Used for correctly binding values to statements.
     */
    auto not(/* IExpression|Closure */string[] aconditions, STRINGAA passedTypes = null) {
        return _add(["NOT": conditions], passedTypes);
    }
    
    /**
     * Returns the number of internal conditions that are stored in this expression.
     * Useful to determine if this expression object is void or it will generate
     * a non-empty string when compiled
     */
    size_t count() {
        return count(_conditions);
    }
    
    // Builds equal condition or assignment with identifier wrapping.
    auto equalFields(string leftFieldName, string rightFieldName) {
         wrapIdentifier = auto (field) {
            if (cast(IExpression)field) {
                return field;
            }
            return new DIdentifierExpression(field);
        };

        return _eq(wrapIdentifier(leftFieldName),  wrapIdentifier(rightFieldName));
    }
    
    string sql(DValueBinder aBinder) {
        size_t length = count();
        if (len == 0) {
            return null;
        }
        auto conjunction = _conjunction;
        auto templateText = len == 1 ? "%s' : '(%s)";
        auto someParts = null;
        foreach (part, _conditions) {
            if (cast(DQuery)part) {
                part = "(" ~ part.sql(aBinder) ~ ")";
            } else if (cast(IExpression)part) {
                part = part.sql(aBinder);
            }
            if (part != "") {
                someParts ~= part;
            }
        }
        return templateText.format(join(" conjunction ", someParts));
    }

    void traverse(Closure aCallback) {
        _conditions.each!((condition) {
            if (cast(IExpression)c) {
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
     */
    void iterateParts(Closure aCallback) {
        someParts = null;
        foreach (myKey: c; _conditions) {
            aKey = &myKey;
            part = aCallback(c, aKey);
            if (part !is null) {
                someParts[aKey] = part;
            }
        }
       _conditions = someParts;
    }
    
    // Returns true if this expression contains any other nested IExpression objects
    bool hasNestedExpression() {
        _conditions.any!(condition => cast(IExpression)condition);
    }
    
    /**
     * Auxiliary auto used for decomposing a nested array of conditions and build
     * a tree structure inside this object to represent the full SQL expression.
     * String conditions are stored directly in the conditions, while any other
     * representation is wrapped around an adequate instance or of this class.
     * Params:
     * Json[string] conditions list of conditions to be stored in this object
     * fieldTypes list of types associated on fields referenced in conditions
     */
    protected void _addConditions(Json[string] conditions, STRINGAA fieldTypes) {
         operators = ["and", "or", "xor"];

        typeMap = getTypeMap().setTypes(fieldTypes);

        foreach (myKey: c; conditions) {
            numericKey = isNumeric(myKey);

            if (cast(DClosure)c) {
                expr = new static([], typeMap);
                c = c(expr, this);
            }
            if (numericKey && c.isEmpty) {
                continue;
            }
             isArray = isArray(c);
             isOperator = isNot = false;
            if (!numericKey) {
                normalizedKey = myKey.lower;
                 isOperator = normalizedKey.isIn(operators);
                 isNot = normalizedKey == "not";
            }
            if ((isOperator ||  isNot) && (isArray || cast(DCountable)c) && count(c) == 0) {
                continue;
            }
            if (numericKey && cast(IExpression)c) {
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
     */
    protected /* IExpression| */ string _parseCondition(string acondition, Json valueToBound) {
        auto expression = condition.strip;
        string operator = "=";
        size_t spaces = substr_count(expression, " ");
        // Handle expression values that contain multiple spaces, such as
        // operators with a space in them like `field IS NOT` and
        // `field NOT LIKE`, or combinations with auto expressions
        // like `CONCAT(first_name, " ", last_name) IN`.
        if (spaces > 1) {
            string[] someParts = expression.split(" ");
            if (preg_match("/(is not|not \w+)$/i", expression)) {
                auto last = someParts.pop();
                auto second = someParts.pop();
                someParts ~= "{second} {last}".mustache(["second": second, "last": last]);
            }
             operator = someParts.pop();
            expression = someParts.join(" ");
        } else if (spaces == 1) {
            string[] someParts = split(" ", expression, 2);
            [expression,  operator] = someParts;
        }
         operator = operator.strip.upper;
        auto type = getTypeMap().type(expression);
        auto typeMultiple = (isString(type) && type.contains("[]"));
        if (isIn(operator, ["IN", "NOT IN"]) || typeMultiple) {
            type = type ? type : "string";
            if (!typeMultiple) {
                type ~= "[]";
            }
             operator = operator == "=" ? "IN" :  operator;
             operator = operator == "!=" ? "NOT IN" :  operator;
            typeMultiple = true;
        }

        if (typeMultiple) {
            valueToBound = cast(IExpression)valueToBound  ? valueToBound : /* (array) */valueToBound;
        }
        if (valueToBound.isNull) {
            if (operator == "IS") {
                return new DUnaryExpression(
                    "IS NULL",
                    new DIdentifierExpression(expression),
                    UnaryExpression.POSTFIX
               );
            }
            if (operator == "IS NOT") {
                return new DUnaryExpression(
                    "IS NOT NULL",
                    new DIdentifierExpression(expression),
                    UnaryExpression.POSTFIX
               );
            }
        }
        else {
            if (operator == "IS") {
                operator = "=";
            }
            if (operator == "IS NOT") {
                operator = "!=";
            }
        }
        if (valueToBound.isNull && _conjunction != ",") {
            throw new DInvalidArgumentException(
                "Expression `%s` is missing operator (IS, IS NOT) with `null` value.".format(expression)
           );
        }
        return new DComparisonExpression(expression, valueToBound, type,  operator);
    }
    
    // Returns the type name for the passed field if it was stored in the typeMap
    protected string _calculateType(IExpression fieldExpression) {
        auto field = cast(IdentifierExpression)fieldExpression ? field.getIdentifier() : field;
    }
    protected string _calculateType(string fieldName) {
        auto field = cast(IdentifierExpression)field ? field.getIdentifier() : field;
        if (!isString(field)) {
            return null;
        }
        return _getTypeMap().type(field);
    }
    
    // this.clone object and its subtree of expressions.
    void clone() {
        foreach (index: condition; _conditions) {
            if (cast(IExpression)condition) {
               _conditions[index] = condition.clone;
            }
        }
    }
}
mixin(ExpressionCalls!("Query"));
