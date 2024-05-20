module uim.databases.classes.expressions.orderby;

import uim.databases;

@safe:

// An expression object for ORDER BY clauses
class DOrderByExpression : DQueryExpression {
    mixin(ExpressionThis!("OrderBy"));

    this(
        /* IExpression */ string[] sortColumns = null,
        TypeMap types = null,
        string conjunctionName = ""
    ) {
        super(sortColumns, types, conjunctionName);
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
     * Json[string] conditions list of order by expressions
     * @param Json[string] types list of types associated on fields referenced in conditions
     */
    protected void _addConditions(Json[string] conditions, Json[string] associatedTypes) {
        conditions.byKeyValue.each!((kv) {
            if (
                isString(kv.key) &&
                isString(kv.value) &&
                !in_array(kv.value, ["ASC", "DESC"], true)
            ) {
                throw new DInvalidArgumentException(
                    "Passing extra expressions by associative array (`\'%s\": \'%s\'`) " ~
                    "is not allowed to avoid potential SQL injection. " ~
                    "Use QueryExpression or numeric array instead."
                    .format(kv.key, kv.value)
                );
            }
        });
       _conditions = array_merge(_conditions, conditions);
    } */
}
mixin(ExpressionCalls!("OrderBy"));
