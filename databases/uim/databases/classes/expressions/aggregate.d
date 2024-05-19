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
     */
    void filter(IExpression|Closure|string[] aconditions, STRINGAA typeNames = null) {
        _filter ??= new DQueryExpression();

        if (cast(DClosure)conditions ) {
            conditions = conditions(new QueryExpression());
        }
        _filter.add(conditions, typeNames);
    }
    
    /**
     * Adds an empty `OVER()` window expression or a named window epression.
     * Params:
     * string windowName Window name
     */
    void over(string windowName = null) {
        auto window = getWindow();
        if (!windowName.isEmpty) {
            // Set name manually in case this was chained from FunctionsBuilder wrapper
             window.name(windowName);
        }
    }
 
    void partition(IExpression|Closure|string[] apartitions) {
        getWindow().partition(partitions);
    }

    auto order(IExpression|Closure|string[] fieldNames) {
        return _orderBy(fields);
    }
 
    void orderBy(IExpression|Closure|string[] fieldNames) {
        getWindow().orderBy(fields);
    }
 
    void range(IExpression|string|int start, IExpression|string|int end = 0) {
        getWindow().range(start, end);
    }
 
    void rows(int start, int end = 0) {
        getWindow().rows(start, end);
    }
 
    void groups(int start, int end = 0) {
        getWindow().groups(start, end);
    }
 
    void frame(
        string atype,
        IExpression|string|int startOffset,
        string astartDirection,
        IExpression|string|int endOffset,
        string aendDirection
    ) {
        getWindow().frame(type, startOffset, startDirection, endOffset, endDirection);
    }
 
    void excludeCurrent() {
        getWindow().excludeCurrent();
    }
 
    void excludeGroup() {
        getWindow().excludeGroup();
    }
 
    void excludeTies() {
        getWindow().excludeTies();
    }

    /**
     * Returns or creates WindowExpression for function.
     */
    protected DWindowExpression getWindow() {
        return _window ??= new WindowExpression();
    }
    string sql(DValueBinder aBinder) {
        string result = super.sql(aBinder);
        if (!_filter.isNull) {
            result ~= " FILTER (WHERE " ~ _filter.sql(aBinder) ~ ")";
        }
        if (!_window.isNull) {
            result ~= _window.isNamedOnly() 
                ? " OVER " ~ _window.sql(aBinder)
                : " OVER (" ~ _window.sql(aBinder) ~ ")";
        }
        return result;
    }
 
    void traverse(Closure aCallback) {
        super.traverse(aCallback);
        if (!_filter.isNull) {
            aCallback(_filter);
            _filter.traverse(aCallback);
        }
        if (!_window.isNull) {
            aCallback(_window);
            _window.traverse(aCallback);
        }
    }
 
    size_t count() {
        size_t result = super.count();
        if (!_window.isNull) {
            result = result + 1;
        }
        return result;
    }

    // Clone this object and its subtree of expressions.
    void clone() {
        super.clone();
        if (!_filter.isNull) {
            _filter = clone _filter;
        }
        if (!_window.isNull) {
            _window = clone _window;
        }
    } */
}
mixin(ExpressionCalls!("Aggregate"));
