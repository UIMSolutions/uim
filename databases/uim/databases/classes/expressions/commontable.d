module uim.databases.classes.expressions.commontable;

import uim.databases;

@safe:

// An expression that represents a common table expression definition.
class DCommonTableExpression : IExpression {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));
    // The CTE name.
    protected DIdentifierExpression _cteName;

    // The field names to use for the CTE.
    protected DIdentifierExpression[] _fields;

    // The CTE query definition.
    protected IExpression aQuery = null;

    // Whether the CTE is materialized or not materialized.
    protected string amaterialized = null;

    // Whether the CTE is recursive.
    protected bool recursive = false;

    /*
    this(string cteName = "", IExpression cteQuery = null) {
       _cteName = new DIdentifierExpression(cteName);
        if (cteQuery) {
            _query(cteQuery);
        }
    }

    this(string cteName = "", IClosure cteQuery) {
       _cteName = new DIdentifierExpression(cteName);
        if (cteQuery) {
            _query(cteQuery);
        }
    }
    
    /**
     * Sets the name of this CTE.
     *
     * This is the named you used to reference the expression
     * in select, insert, etc queries.
     */
    void name(string cteName) {
        _name = new DIdentifierExpression(cteName);
    }
    
    // Sets the query for this CTE.
    // TODO void query(IExpression|Closure cteQuery) {
    // }
    void query(/* IExpression| */ Closure cteQuery) {
        if (cast(DClosure)cteQuery) {
            cteQuery = aQuery();
            if (!(cast(IExpression)cteQuery)) {
                throw new DatabaseException(
                    "You must return an `IExpression` from a Closure passed to `query()`."
               );
            }
        }
        _query = cteQuery;
    }
    
    /**
     * Adds one or more fields (arguments) to the CTE.
     * Params:
     * \UIM\Database\Expression\IdentifierExpression|array<\UIM\Database\Expression\IdentifierExpression>|string[]|string fieldNames Field names
     */
    void field(/* IdentifierExpression[] */ string[] fieldNames) {
        fieldNames = /* (array) */fieldNames;
        /** @var array<string|\UIM\Database\Expression\IdentifierExpression> fields */
        fieldNames.each!((field) {
            if (!(cast(IdentifierExpression)field)) {
                field = new DIdentifierExpression(field);
            }
        });
        /** @var array<\UIM\Database\Expression\IdentifierExpression>  mergedFields */
        _fields = chain(_fields, fieldNames);
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
        return _recursive;
    }

    // Sets this CTE as recursive.
    void recursive() {
        this.recursive = true;
    }
 
    string sql(DValueBinder aBinder) {
        string myFields = "";
        if (_fields) {
            someExpressions = array_map(fn (IdentifierExpression  anException):  anException.sql(aBinder), _fields);
            myFields = "(%s)".format(join(", ", someExpressions));
        }

        strng suffix = this.materialized ? this.materialized ~ " " : "";
        return 
            "%s%s AS %s(%s)".format(
            this.name.sql(aBinder),
            myFields,
            suffix,
            _query ? _query.sql(aBinder): ""
       );
    }
 
    void traverse(Closure aCallback) {
        aCallback(this.name);
        _fields.each!((filed) {
            aCallback(field);
            field.traverse(aCallback);
        });
        
        if (_query) {
            aCallback(_query);
            _query.traverse(aCallback);
        }
    }
    
    // Clones the inner expression objects.
    void clone() {
        this.name = this.clone.name;
        if (_query) {
            _query = clone _query;
        }
        foreach (aKey: field; _fields) {
            _fields[aKey] = clone field;
        }
    } */
}
