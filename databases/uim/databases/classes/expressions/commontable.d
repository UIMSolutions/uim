module uim.databases.Expression;

import uim.databases;

@safe:

// An expression that represents a common table expression definition.
class CommonTableExpression : IExpression {
    // The CTE name.
    protected IdentifierExpression _cteName;

    // The field names to use for the CTE.
    protected IdentifierExpression[] _fields;

    // The CTE query definition.
    protected IExpression aQuery = null;

    // Whether the CTE is materialized or not materialized.
    protected string amaterialized = null;

    // Whether the CTE is recursive.
    protected bool recursive = false;

    this(string cteName = "", IExpression cteQuery = null) {
       _cteName = new IdentifierExpression(cteName);
        if (cteQuery) {
            this.query(cteQuery);
        }
    }

    this(string cteName = "", Closure cteQuery) {
       _cteName = new IdentifierExpression(cteName);
        if (cteQuery) {
            this.query(cteQuery);
        }
    }
    
    /**
     * Sets the name of this CTE.
     *
     * This is the named you used to reference the expression
     * in select, insert, etc queries.
     */
    void name(string cteName) {
        _name = new IdentifierExpression(cteName);
    }
    
    /**
     * Sets the query for this CTE.
     * Params:
     * \UIM\Database\IExpression|\Closure aQuery CTE query
     */
    void query(IExpression|Closure aQuery) {
    }
    void query(IExpression|Closure aQuery) {
        if (cast(Closure)aQuery) {
            aQuery = aQuery();
            if (!(cast(IExpression)aQuery)) {
                throw new DatabaseException(
                    "You must return an `IExpression` from a Closure passed to `query()`."
                );
            }
        }
        this.query = aQuery;
    }
    
    /**
     * Adds one or more fields (arguments) to the CTE.
     * Params:
     * \UIM\Database\Expression\IdentifierExpression|array<\UIM\Database\Expression\IdentifierExpression>|string[]|string afields Field names
     */
    void field(IdentifierExpression|string[] afields) {
        auto fields = (array)fields;
        /** @var array<string|\UIM\Database\Expression\IdentifierExpression> fields */
        fields.each!((field) {
            if (!(cast(IdentifierExpression)field)) {
                field = new IdentifierExpression(field);
            }
        });
        /** @var array<\UIM\Database\Expression\IdentifierExpression>  mergedFields */
        this.fields = chain(this.fields, fields);
    }

    // Sets this CTE as materialized.
    void materialized() {
        this.materialized = "MATERIALIZED";
    }

    // Sets this CTE as not materialized.
    void notMaterialized() {
        this.materialized = "NOT MATERIALIZED";
    }

    // Gets whether this CTE is recursive.
    bool isRecursive() {
        return this.recursive;
    }

    // Sets this CTE as recursive.
    void recursive() {
        this.recursive = true;
    }
 
    string sql(ValueBinder aBinder) {
        string myFields = "";
        if (this.fields) {
            someExpressions = array_map(fn (IdentifierExpression  anException):  anException.sql(aBinder), this.fields);
            myFields = "(%s)".format(join(", ", someExpressions));
        }

        strng suffix = this.materialized ? this.materialized ~ " " : "";
        return 
            "%s%s AS %s(%s)".format(
            this.name.sql(aBinder),
            myFields,
            suffix,
            this.query ? this.query.sql(aBinder): ""
        );
    }
 
    void traverse(Closure aCallback) {
        aCallback(this.name);
        this.fields.each!((filed) {
            aCallback(field);
            field.traverse(aCallback);
        });
        
        if (this.query) {
            aCallback(this.query);
            this.query.traverse(aCallback);
        }
    }
    
    // Clones the inner expression objects.
    void __clone() {
        this.name = clone this.name;
        if (this.query) {
            this.query = clone this.query;
        }
        foreach (aKey: field; this.fields) {
            this.fields[aKey] = clone field;
        }
    }
}
