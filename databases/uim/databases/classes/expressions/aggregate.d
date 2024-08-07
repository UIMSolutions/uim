module uim.databases.classes.expressions.aggregate;

import uim.databases;

@safe:

/**
 * This represents an SQL aggregate auto expression in an SQL statement.
 * Calls can be constructed by passing the name of the auto and a list of params.
 * For security reasons, all params passed are quoted by default unless
 * explicitly told otherwise.
 */
class DAggregateExpression : DFunctionExpression { // TODO}, IWindow {
    mixin(ExpressionThis!("Aggregate"));

    
    protected IQueryExpression _filter = null;

    protected DWindowExpression _window = null;
// Returns or creates WindowExpression for function.
    protected DWindowExpression getWindow() {
if (_window.isNull) {
_window = new WindowExpression();
}
        return _window;
    }

    /**
     * Adds conditions to the FILTER clause. The conditions are the same format as
     * `Query.where()`.
     * Params:
     * \UIM\Database\IExpression|\/*Closure|* / string[] aconditions The conditions to filter on.
     * typeNames Associative array of type names used to bind values to query
     */
    void filter(/* IExpression|Closure */string[] aconditions, STRINGAA typeNames = null) {
        _filter = _filter : new DQueryExpression();

        if (cast(DClosure)conditions) {
            conditions = conditions(new QueryExpression());
        }
        _filter.add(conditions, typeNames);
    }
    
    // Adds an empty `OVER()` window expression or a named window epression.
    void over(string windowName = null) {
        auto window = getWindow();
        if (!windowName.isEmpty) {
            // Set name manually in case this was chained from FunctionsBuilder wrapper
             window.name(windowName);
        }
    }
 
    void partition(/* IExpression|Closure */string[] apartitions) {
        getWindow().partition(partitions);
    }

    auto order(/* IExpression|Closure */string[] fieldNames) {
        return _orderBy(fields);
    }
 
    void orderBy(/* IExpression|Closure */string[] fieldNames) {
        getWindow().orderBy(fields);
    }
 
    void range(/* IExpression| */ string|int start, /* IExpression| */ string|int end = 0) {
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
        /* IExpression| */ string|int startOffset,
        string astartDirection,
        /* IExpression| */ string|int endOffset,
        string aendDirection
   ) {
        window().frame(type, startOffset, startDirection, endOffset, endDirection);
    }
 
    void excludeCurrent() {
        window().excludeCurrent();
    }
 
    void excludeGroup() {
        window().excludeGroup();
    }
 
    void excludeTies() {
        window().excludeTies();
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

    // this.clone object and its subtree of expressions.
    void clone() {
        super.clone();
        if (!_filter.isNull) {
            _filter = _filter.clone;
        }
        if (!_window.isNull) {
            _window = _window.clone;
        }
    } 
}
mixin(ExpressionCalls!("Aggregate"));
