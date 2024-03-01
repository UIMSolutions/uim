module uim.databases.Expression;

import uim.databases;

@safe:

/**
 * An expression object to contain values being inserted.
 *
 * Helps generate SQL with the correct number of placeholders and bind
 * values correctly into the statement.
 */
class ValuesExpression : IExpression {
    mixin ExpressionTypeCasterTrait;
    mixin TypeMapTrait;

    // Array of values to insert.
    protected array _values = [];

    // List of columns to ensure are part of the insert.
    protected array _columns = [];

    // The Query object to use as a values expression
    protected Query _query = null;

    // Whether values have been casted to expression already.
    protected bool _castedExpressions = false;

    /**
     * Constructor
     * Params:
     * array someColumns The list of columns that are going to be part of the values.
     * @param \UIM\Database\TypeMap typeMap A dictionary of column ~ type names
     */
    this(array someColumns, TypeMap typeMap) {
       _columns = someColumns;
        this.setTypeMap($typeMap);
    }
    
    /**
     * Add a row of data to be inserted.
     * Params:
     * \UIM\Database\Query|array  someValues Array of data to append into the insert, or
     *  a query for doing INSERT INTO .. SELECT style commands
     * @throws \UIM\Database\Exception\DatabaseException When mixing array + Query data types.
     */
    void add(Query|array  someValues) {
        if (
            (count(_values) && cast(Query)someValues) ||
            (_query && isArray(someValues))
        ) {
            throw new DatabaseException(
                "You cannot mix subqueries and array values in inserts."
            );
        }
        if (cast(Query)someValues) {
            this.setQuery(someValues);

            return;
        }
       _values ~=  someValues;
       _castedExpressions = false;
    }

    /**
     * Sets the columns to be inserted.
     * Params:
     * array someColumns Array with columns to be inserted.
     */
    void setColumns(array someColumns) {
       _columns = someColumns;
       _castedExpressions = false;
    }

    // Gets the columns to be inserted.
    array getColumns() {
        return _columns;
    }

    /**
     * Get the bare column names.
     *
     * Because column names could be identifier quoted, we
     * need to strip the identifiers off of the columns.
     */
    protected array _columnNames() {
        auto someColumns = _columns
            .map!(col => isString(col) ? trim(col, "`[]'") : col);

        return someColumns;
    }

    // Sets the values to be inserted.
    void setValues(array  valuesToInsert) {
       _values =  valuesToInsert;
       _castedExpressions = false;
    }

    // Gets the values to be inserted.
    array getValues() {
        if (!_castedExpressions) {
           _processExpressions();
        }
        return _values;
    }

    // Set/Get the query object to be used as the values expression to be evaluated to insert records in the table.
    mixin(TProperty!("Query", "query"));
 
    string sql(ValueBinder aBinder) {
        if (_values.isEmpty && _query.isEmpty) {
            return "";
        }
        if (!_castedExpressions) {
           _processExpressions();
        }
        
        auto colNames = _columnNames();
        $defaults = array_fill_keys(colNames, null);
        $placeholders = [];

        types = [];
        typeMap = this.getTypeMap();
        $defaults.byKeyValue
            .each!(kv => types[kv.key] = typeMap.type(kv.key));

        foreach ($row; _values ) {
            $row += $defaults;
            $rowPlaceholders = [];

            foreach ($column; colNames) {
                auto aValue = $row[$column];

                if (cast(IExpression)aValue ) {
                    $rowPlaceholders ~= "(" ~ aValue.sql(aBinder) ~ ")";
                    continue;
                }
                auto $placeholder = aBinder.placeholder("c");
                auto $rowPlaceholders ~= $placeholder;
                aBinder.bind($placeholder, aValue, types[$column]);
            }
            $placeholders ~= join(", ", $rowPlaceholders);
        }
        aQuery = this.getQuery();
        if (aQuery) {
            return " " ~ aQuery.sql(aBinder);
        }
        return " VALUES (%s)".format(join("), (", $placeholders));
    }
 
    void traverse(Closure aCallback) {
        if (_query) {
            return;
        }
        if (!_castedExpressions) {
           _processExpressions();
        }
        _values.each!((value) {
            if (cast(IExpression)$v) {
                value.traverse(aCallback);
            }
            if (!isArray(value)) {
                continue;
            }
            value
                .filter!(field => cast(IExpression)field)
                .each!((field) {
                    aCallback(field);
                    field.traverse(aCallback);
                });
            });
        }
    }
    
    // Converts values that need to be casted to expressions
    protected void _processExpressions() {
        auto types = [];
        auto typeMap = this.getTypeMap();

        auto someColumns = _columnNames();
        someColumns
            .filter!(colName => isString(colName) || isInt(colName))
            .each!(colName => types[colName] = typeMap.type(colName));

        types = _requiresToExpressionCasting($types);

        if (isEmpty($types)) {
            return;
        }
        foreach (_values as $row:  someValues) {
            types.byKeyValue
                .each!($col: type)
                /** @var \UIM\Database\Type\IExpressionType type */
               _values[$row][$col] = type.toExpression(someValues[$col]);
            }
        }
       _castedExpressions = true;
    }
}
