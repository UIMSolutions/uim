module uim.databases.classes.expressions.aggregate;

import uim.databases;

@safe:

/*
/**
 * This represents an SQL aggregate auto expression in an SQL statement.
 * Calls can be constructed by passing the name of the auto and a list of params.
 * For security reasons, all params passed are quoted by default unless
 * explicitly told otherwise.
 */
class DAggregateExpression : DFunctionExpression { // TODO}, IWindow {
    mixin(ExpressionThis!("Aggregate"));

    /* 
    protected IQueryExpression filter = null;

    protected DWindowExpression  window = null;

    /**
     * Adds conditions to the FILTER clause. The conditions are the same format as
     * `Query.where()`.
     * Params:
     * \UIM\Database\IExpression|\Closure|string[] aconditions The conditions to filter on.
     * typeNames Associative array of type names used to bind values to query

     * @see \UIM\Database\Query.where()
     * /
    void filter(IExpression|Closure|string[] aconditions, STRINGAA typeNames = []) {
        this.filter ??= new QueryExpression();

        if (cast(DClosure)conditions ) {
            conditions = conditions(new QueryExpression());
        }
        this.filter.add(conditions, typeNames);
    }
    
    /**
     * Adds an empty `OVER()` window expression or a named window epression.
     * Params:
     * string|null windowName Window name
     * /
    void over(string windowName = null) {
        auto  window = this.getWindow();
        if (!windowName.isEmpty) {
            // Set name manually in case this was chained from FunctionsBuilder wrapper
             window.name(windowName);
        }
    }
 
    void partition(IExpression|Closure|string[] apartitions) {
        this.getWindow().partition(partitions);
    }

    auto order(IExpression|Closure|string[] afields) {
        return _orderBy(fields);
    }
 
    void orderBy(IExpression|Closure|string[] afields) {
        this.getWindow().orderBy(fields);
    }
 
    void range(IExpression|string|int start, IExpression|string|int end = 0) {
        this.getWindow().range(start, end);
    }
 
    void rows(int start, int end = 0) {
        this.getWindow().rows(start, end);
    }
 
    void groups(int start, int end = 0) {
        this.getWindow().groups(start, end);
    }
 
    void frame(
        string atype,
        IExpression|string|int startOffset,
        string astartDirection,
        IExpression|string|int endOffset,
        string aendDirection
    ) {
        this.getWindow().frame(type, startOffset, startDirection, endOffset, endDirection);
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
     * /
    protected DWindowExpression getWindow() {
        return _window ??= new WindowExpression();
    }
    string sql(DValueBinder aBinder) {
        string result = super.sql(aBinder);
        if (!this.filter is null) {
            result ~= " FILTER (WHERE " ~ this.filter.sql(aBinder) ~ ")";
        }
        if (!this.window is null) {
            result ~= this.window.isNamedOnly() 
                ? " OVER " ~ this.window.sql(aBinder)
                : " OVER (" ~ this.window.sql(aBinder) ~ ")";
        }
        return result;
    }
 
    void traverse(Closure aCallback) {
        super.traverse(aCallback);
        if (!this.filter is null) {
            aCallback(this.filter);
            this.filter.traverse(aCallback);
        }
        if (!this.window is null) {
            aCallback(this.window);
            this.window.traverse(aCallback);
        }
    }
 
    size_t count() {
        size_t result = super.count();
        if (!this.window is null) {
            result = result + 1;
        }
        return result;
    }

    // Clone this object and its subtree of expressions.
    void __clone() {
        super.__clone();
        if (!this.filter is null) {
            this.filter = clone this.filter;
        }
        if (this.window !isNull) {
            this.window = clone this.window;
        }
    } */
}
mixin(ExpressionCalls!("Aggregate"));
