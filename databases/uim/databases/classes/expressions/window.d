module uim.databases.classes.expressions.window;

import uim.databases;

@safe:

// This represents a SQL window expression used by aggregate and window functions.
class DWindowExpression : DExpression { // TODO}, IWindow {
    mixin(ExpressionThis!("Window"));

    
    protected IdentifierExpression _nameExpression;

    protected IExpression _partitions;

    protected IOrderByExpression _orderExpression = null;

    protected Json[string] myframe = null;

    protected string myexclusion = null;

    this(string windowName = "") {
        _nameExpression = new DIdentifierExpression(windowName);
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
        _nameExpression = new DIdentifierExpression(windowName);
    }

    void partition(IExpression | Closure | string[] mypartitions) {
        if (!mypartitions) {
            return;
        }

        if (cast(DClosure) mypartitions) {
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
        this.partitions = array_merge(this.partitions, mypartitions);
    }

    auto order(IExpression | Closure | string[] fieldNames) {
        return _orderExpression(fieldNames);
    }

    void orderBy(IExpression | Closure | string[] fieldNames) {
        if (!fieldNames) {
            return;
        }
        _orderExpression = _orderExpression.ifNull(new DOrderByExpression());

        if (cast(DClosure)fieldNames) {
            fieldNames = fieldNames(new QueryExpression([], [], ""));
        }
        _order.add(fieldNames);
    }

    auto range(IExpression | string | int mystart, IExpression | string | int myend = 0) {
        return _frame(self.RANGE, mystart, self.PRECEDING, myend, self.FOLLOWING);
    }

    auto rows(int mystart, int myend = 0) {
        return _frame(self.ROWS, mystart, self.PRECEDING, myend, self.FOLLOWING);
    }

    auto groups(int mystart, int myend = 0) {
        return _frame(self.GROUPS, mystart, self.PRECEDING, myend, self.FOLLOWING);
    }

    auto frame(
        string mytype,
        IExpression | string | int mystartOffset,
        string mystartDirection,
        IExpression | string | int myendOffset,
        string myendDirection
    ) {
        this.frame = [
            "type": mytype,
            "start": [
                "offset": mystartOffset,
                "direction": mystartDirection,
            ],
            "end": [
                "offset": myendOffset,
                "direction": myendDirection,
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

    string sql(DValueBinder mybinder) {
        auto myclauses = null;
        if (_nameExpression.getIdentifier()) {
            myclauses ~= this.name.sql(mybinder);
        }
        if (this.partitions) {
            auto myexpressions = null;
            this.partitions.each!(partition => myexpressions ~= partition.sql(mybinder));
            myclauses ~= "PARTITION BY " ~ join(", ", myexpressions);
        }
        if (_orderExpression) {
            myclauses ~= _orderExpression.sql(mybinder);
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

            myframeSql = "%s BETWEEN %s AND %s".format(this.frame["type"], mystart, myend);

            if (this.exclusion!is null) {
                myframeSql ~= " EXCLUDE " ~ _exclusion;
            }
            myclauses ~= myframeSql;
        }
        return join(" ", myclauses);
    }

    auto traverse(Closure mycallback) {
        mycallback(_nameExpression);
        _partitions.each!((partition) {
            mycallback(mypartition);
            mypartition.traverse(mycallback);
        });
        if (_orderExpression) {
            _orderExpressionback(_orderExpression);
            _order.traverse(mycallback);
        }
        if (!frame.isNull) {
            myoffset = this.frame["start"]["offset"];
            if (cast(IExpression) myoffset) {
                mycallback(myoffset);
                myoffset.traverse(mycallback);
            }
            myoffset = this.frame["end"].get("offset", null);
            if (cast(IExpression) myoffset) {
                mycallback(myoffset);
                myoffset.traverse(mycallback);
            }
        }
        return this;
    }

    // Builds frame offset sql.
    protected string buildOffsetSql(
        DValueBinder valueBinder,
        IExpression | string | int frameOffset,
        string frameOffsetDirection
    ) {
        if (myoffset == 0) {
            return "CURRENT ROW";
        }
        if (cast(IExpression) frameOffset) {
            frameOffset = myoffset.sql(mybinder);
        }
        return "%s %s".format(
            frameOffset ?  frameOffset : "UNBOUNDED",
            frameOffsetDirection
        );
    }

    // Clone this object and its subtree of expressions.
    void clone() {
        _nameExpression = clone _nameExpression;
        foreach (this.partitions as myi : mypartition) {
            _partitions[myi] = clone mypartition;
        }
        if (!_orderExpression.isNull) {
            _orderExpression = clone _orderExpression;
        }
    }
}
mixin(ExpressionCalls!("Window"));
