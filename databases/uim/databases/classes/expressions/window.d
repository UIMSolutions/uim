module uim.databases.expressions.window;

import uim.databases;

@safe:

/*
/**
 * This represents a SQL window expression used by aggregate and window functions.
 */
class WindowExpression : IExpression, WindowInterface {
    protected IdentifierExpression  myname;

    protected IExpression mypartitions = [];

    protected OrderByExpression myorder = null;

    protected array myframe = null;

    protected string myexclusion = null;

    this(string windowName = "") {
        this.name = new IdentifierExpression(windowName);
    }
    
    /**
     * Return whether is only a named window expression.
     *
     * These window expressions only specify a named window and do not
     * specify their own partitions, frame or order.
     */
    bool isNamedOnly() {
        return this.name.getIdentifier() && (!this.partitions && !this.frame && !this.order);
    }
    
    // Sets the window name.
    void name(string windowName) {
        this.name = new IdentifierExpression(windowName);
    }
 
    void partition(IExpression|Closure|string[] mypartitions) {
        if (!mypartitions) {
            return;
        }
        if (cast(Closure)mypartitions) {
             mypartitions = mypartitions(new QueryExpression([], [], ""));
        }
        if (!isArray(mypartitions)) {
             mypartitions = [mypartitions];
        }
        foreach (mypartitions as & mypartition) {
            if (isString(mypartition)) {
                 mypartition = new IdentifierExpression(mypartition);
            }
        }
        this.partitions = array_merge(this.partitions,  mypartitions);
    }
 
    auto order(IExpression|Closure|string[] myfields) {
        return this.orderBy(myfields);
    }
 
    void orderBy(IExpression|Closure|string[] myfields) {
        if (!myfields) {
            return;
        }
        this.order ??= new OrderByExpression();

        if (cast(Closure)myfields) {
             myfields = myfields(new QueryExpression([], [], ""));
        }
        this.order.add(myfields);
    }
 
    auto range(IExpression|string|int  mystart, IExpression|string|int  myend = 0) {
        return this.frame(self.RANGE,  mystart, self.PRECEDING,  myend, self.FOLLOWING);
    }
 
    auto rows(int mystart, int myend = 0) {
        return this.frame(self.ROWS,  mystart, self.PRECEDING,  myend, self.FOLLOWING);
    }
 
    auto groups(int mystart, int myend = 0) {
        return this.frame(self.GROUPS,  mystart, self.PRECEDING,  myend, self.FOLLOWING);
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
 
    string sql(ValueBinder  mybinder) {
        auto myclauses = [];
        if (this.name.getIdentifier()) {
             myclauses ~= this.name.sql(mybinder);
        }
        if (this.partitions) {
            auto myexpressions = [];
            this.partitions.each!(partition => myexpressions ~= partition.sql(mybinder));
             myclauses ~= "PARTITION BY " ~ join(", ",  myexpressions);
        }
        if (this.order) {
             myclauses ~= this.order.sql(mybinder);
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
                 myframeSql ~= " EXCLUDE " ~ this.exclusion;
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
        if (this.order) {
             mycallback(this.order);
            this.order.traverse(mycallback);
        }
        if (this.frame !isNull) {
             myoffset = this.frame["start"]["offset"];
            if (cast(IExpression)myoffset ) {
                 mycallback(myoffset);
                 myoffset.traverse(mycallback);
            }
             myoffset = this.frame["end"]["offset"] ?? null;
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
     * \UIM\Database\ValueBinder  mybinder Value binder
     * @param \UIM\Database\IExpression|string|int  myoffset Frame offset
     * @param string mydirection Frame offset direction
     */
    protected string buildOffsetSql(
        ValueBinder  mybinder,
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
    void __clone() {
        this.name = clone this.name;
        foreach (this.partitions as  myi:  mypartition) {
            this.partitions[myi] = clone  mypartition;
        }
        if (this.order !isNull) {
            this.order = clone this.order;
        }
    }
}
