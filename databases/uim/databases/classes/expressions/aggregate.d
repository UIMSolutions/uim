module uim.databases.classes.expressions.aggregatex;

import uim.databases;

@safe:

/*
/**
 * This represents an SQL aggregate auto expression in an SQL statement.
 * Calls can be constructed by passing the name of the auto and a list of params.
 * For security reasons, all params passed are quoted by default unless
 * explicitly told otherwise.
 */
class AggregateExpression : FunctionExpression, IWindow {
    protected QueryExpression $filter = null;

    protected WindowExpression $window = null;

    /**
     * Adds conditions to the FILTER clause. The conditions are the same format as
     * `Query.where()`.
     * Params:
     * \UIM\Database\IExpression|\Closure|string[] aconditions The conditions to filter on.
     * typeNames Associative array of type names used to bind values to query

     * @see \UIM\Database\Query.where()
     */
    void filter(IExpression|Closure|string[] aconditions, STRINGAA typeNames = []) {
        this.filter ??= new QueryExpression();

        if (cast(Closure)conditions ) {
            conditions = conditions(new QueryExpression());
        }
        this.filter.add(conditions, typeNames);
    }
    
    /**
     * Adds an empty `OVER()` window expression or a named window epression.
     * Params:
     * string|null windowName Window name
     */
    void over(string windowName = null) {
        auto $window = this.getWindow();
        if (!windowName.isEmpty) {
            // Set name manually in case this was chained from FunctionsBuilder wrapper
            $window.name(windowName);
        }
    }
 
    void partition(IExpression|Closure|string[] apartitions) {
        this.getWindow().partition($partitions);
    }

    auto order(IExpression|Closure|string[] afields) {
        return this.orderBy(fields);
    }
 
    void orderBy(IExpression|Closure|string[] afields) {
        this.getWindow().orderBy(fields);
    }
 
    void range(IExpression|string|int $start, IExpression|string|int $end = 0) {
        this.getWindow().range($start, $end);
    }
 
    void rows(int $start, int $end = 0) {
        this.getWindow().rows($start, $end);
    }
 
    void groups(int $start, int $end = 0) {
        this.getWindow().groups($start, $end);
    }
 
    void frame(
        string atype,
        IExpression|string|int $startOffset,
        string astartDirection,
        IExpression|string|int $endOffset,
        string aendDirection
    ) {
        this.getWindow().frame($type, $startOffset, $startDirection, $endOffset, $endDirection);
    }
 
    void excludeCurrent() {
        this.getWindow().excludeCurrent();
    }
 
    void excludeGroup() {
        this.getWindow().excludeGroup();
    }
 
    void excludeTies() {
        this.getWindow().excludeTies();
    }

    /**
     * Returns or creates WindowExpression for function.
     */
    protected WindowExpression getWindow() {
        return this.window ??= new WindowExpression();
    }
    string sql(ValueBinder aBinder) {
        string result = super.sql(aBinder);
        if (!this.filter.isNull) {
            result ~= " FILTER (WHERE " ~ this.filter.sql(aBinder) ~ ")";
        }
        if (!this.window.isNull) {
            result ~= this.window.isNamedOnly() 
                ? " OVER " ~ this.window.sql(aBinder)
                : " OVER (" ~ this.window.sql(aBinder) ~ ")";
        }
        return result;
    }
 
    void traverse(Closure aCallback) {
        super.traverse(aCallback);
        if (!this.filter.isNull) {
            aCallback(this.filter);
            this.filter.traverse(aCallback);
        }
        if (!this.window.isNull) {
            aCallback(this.window);
            this.window.traverse(aCallback);
        }
    }
 
    size_t count() {
        size_t result = super.count();
        if (!this.window.isNull) {
            result = result + 1;
        }
        return result;
    }

    // Clone this object and its subtree of expressions.
    void __clone() {
        super.__clone();
        if (!this.filter.isNull) {
            this.filter = clone this.filter;
        }
        if (this.window !isNull) {
            this.window = clone this.window;
        }
    }
}
