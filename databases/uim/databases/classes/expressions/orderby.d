module uim.databases.classes.expressions.orderby;

import uim.databases;

@safe:

// An expression object for ORDER BY clauses
class DOrderByExpression : DQueryExpression {
    mixin(ExpressionThis!("OrderBy"));

    /**
     * Constructor
     * Params:
     * \UIM\Database\IExpression|string[] aconditions The sort columns
     * @param \UIM\Database\TypeMap|STRINGAA types The types for each column.
     * @param string aconjunction The glue used to join conditions together.
     * /
    this(
        IExpression|string[] aconditions = [],
        TypeMap|array types = [],
        string aConjunction = ""
    ) {
        super(conditions, types, aConjunction);
    }
    string sql(DValueBinder aBinder) {
        string[] sqlOrders;
        foreach (myKey:  direction; _conditions) {
            if (cast(IExpression) direction ) {
                direction = direction.sql(aBinder);
            }
            sqlOrders ~= isNumeric(myKey) ?  direction : "%s %s".format(myKey,  direction);
        }
        return "ORDER BY %s".format(sqlOrders.join(", "));
    }
    
    /**
     * Auxiliary auto used for decomposing a nested array of conditions and
     * building a tree structure inside this object to represent the full SQL expression.
     *
     * New order by expressions are merged to existing ones
     * Params:
     * array conditions list of order by expressions
     * @param array types list of types associated on fields referenced in conditions
     * /
    protected void _addConditions(Json[string] conditions, Json[string] types) {
        foreach (aKey:  val; conditions) {
            if (
                isString(aKey) &&
                isString(val) &&
                !in_array(strtoupper(val), ["ASC", "DESC"], true)
            ) {
                throw new DInvalidArgumentException(
                    "Passing extra expressions by associative array (`\'%s\": \'%s\'`) " ~
                    "is not allowed to avoid potential SQL injection. " ~
                    "Use QueryExpression or numeric array instead."
                    .format(aKey,  val)
                );
            }
        }
       _conditions = array_merge(_conditions, conditions);
    } */
}
mixin(ExpressionCalls!("OrderBy"));
