module uim.databases.classes.expressions.window;

import uim.databases;

@safe:

// This represents a SQL window expression used by aggregate and window functions.
class DWindowExpression : DExpression { // TODO}, IWindow {
    mixin(ExpressionThis!("Window"));

    /*
    protected IdentifierExpression  myname;

    protected IExpression mypartitions;

    protected IOrderByExpression myorder = null;

    // TODO protected Json[string] myframe = null;

    protected string myexclusion = null;

    this(string windowName = "") {
        this.name = new DIdentifierExpression(windowName);
    }
    
    /**
     * Return whether is only a named window expression.
     *
     * These window expressions only specify a named window and do not
     * specify their own partitions, frame or order.
     */
    bool isNamedOnly() {
        return _name.getIdentifier() && (!this.partitions && !this.frame && !_order);
    }
    
    // Sets the window name.
    void name(string windowName) {
        this.name = new DIdentifierExpression(windowName);
    }
 
    void partition(IExpression|Closure|string[] mypartitions) {
        if (!mypartitions) {
            return;
        }
        if (cast(DClosure)mypartitions) {
             mypartitions = mypartitions(new QueryExpression([], [], ""));
        }
        if (!isArray(mypartitions)) {
             mypartitions = [mypartitions];
        }
        foreach (mypartitions as & mypartition) {
            if (isString(mypartition)) {
                 mypartition = new DIdentifierExpression(mypartition);
            }
        }
        this.partitions = array_merge(this.partitions,  mypartitions);
    }
 
    auto order(IExpression|Closure|string[] myfields) {
        return _orderBy(myfields);
    }
 
    void orderBy(IExpression|Closure|string[] myfields) {
        if (!myfields) {
            return;
        }
        _order ??= new DOrderByExpression();

        if (cast(DClosure)myfields) {
             myfields = myfields(new QueryExpression([], [], ""));
        }
        _order.add(myfields);
    }
 
    auto range(IExpression|string|int  mystart, IExpression|string|int  myend = 0) {
        return _frame(self.RANGE,  mystart, self.PRECEDING,  myend, self.FOLLOWING);
    }
 
    auto rows(int mystart, int myend = 0) {
        return _frame(self.ROWS,  mystart, self.PRECEDING,  myend, self.FOLLOWING);
    }
 
    auto groups(int mystart, int myend = 0) {
        return _frame(self.GROUPS,  mystart, self.PRECEDING,  myend, self.FOLLOWING);
    }
 
    auto frame(
        string mytype,
        IExpression|string|int  mystartOffset,
        string mystartDirection,
        IExpression|string|int  myendOffset,
        string myendDirection
    ) {
        this.frame = [
            "type":  mytype,
            "start": [
                "offset":  mystartOffset,
                "direction":  mystartDirection,
            ],
            "end": [
                "offset":  myendOffset,
                "direction":  myendDirection,
            ],
        ];

        return this;
    }
 
    void excludeCurrent() {
        this.exclusion = "CURRENT ROW";
    }
 
    auto excludeGroup() {
        this.exclusion = "GROUP";

        return this;
    }
 
    auto excludeTies() {
        this.exclusion = "TIES";

        return this;
    }
 
    string sql(DValueBinder  mybinder) {
        auto myclauses = null;
        if (this.name.getIdentifier()) {
             myclauses ~= this.name.sql(mybinder);
        }
        if (this.partitions) {
            auto myexpressions = null;
            this.partitions.each!(partition => myexpressions ~= partition.sql(mybinder));
             myclauses ~= "PARTITION BY " ~ join(", ",  myexpressions);
        }
        if (_order) {
             myclauses ~= _order.sql(mybinder);
        }
        if (this.frame) {
             mystart = this.buildOffsetSql(
                 mybinder,
                this.frame["start"]["offset"],
                this.frame["start"]["direction"]
            );
             myend = this.buildOffsetSql(
                 mybinder,
                this.frame["end"]["offset"],
                this.frame["end"]["direction"]
            );

             myframeSql = "%s BETWEEN %s AND %s".format(this.frame["type"],  mystart,  myend);

            if (this.exclusion !isNull) {
                 myframeSql ~= " EXCLUDE " ~ _exclusion;
            }
             myclauses ~= myframeSql;
        }
        return join(" ",  myclauses);
    }
 
    auto traverse(Closure  mycallback) {
         mycallback(this.name);
        foreach (this.partitions as  mypartition) {
             mycallback(mypartition);
             mypartition.traverse(mycallback);
        }
        if (_order) {
             mycallback(_order);
            _order.traverse(mycallback);
        }
        if (this.frame !isNull) {
             myoffset = this.frame["start"]["offset"];
            if (cast(IExpression)myoffset ) {
                 mycallback(myoffset);
                 myoffset.traverse(mycallback);
            }
             myoffset = this.frame["end"].get("offset", null);
            if (cast(IExpression)myoffset ) {
                 mycallback(myoffset);
                 myoffset.traverse(mycallback);
            }
        }
        return this;
    }
    
    /**
     * Builds frame offset sql.
     * Params:
     * \UIM\Database\DValueBinder  mybinder Value binder
     * @param \UIM\Database\IExpression|string|int  myoffset Frame offset
     * @param string mydirection Frame offset direction
     */
    protected string buildOffsetSql(
        DValueBinder  mybinder,
        IExpression|string|int  myoffset,
        string mydirection
    ) {
        if (myoffset == 0) {
            return "CURRENT ROW";
        }
        if (cast(IExpression)myoffset ) {
             myoffset = myoffset.sql(mybinder);
        }
        return 
            "%s %s".format(
             myoffset ?? "UNBOUNDED",
             mydirection
        );
    }
    
    /**
     * Clone this object and its subtree of expressions.
     */
    void clone() {
        this.name = clone this.name;
        foreach (this.partitions as  myi:  mypartition) {
            this.partitions[myi] = clone  mypartition;
        }
        if (_order !isNull) {
            _order = clone _order;
        }
    } */
}
mixin(ExpressionCalls!("Window"));
