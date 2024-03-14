module uim.orm.Query;

/**
 * Factory class for generating instances of Select, Insert, Update, Delete queries.
 */
class QueryFactory {
    /**
     * Create a new Query instance.
     */
    SelectQuery select(Table tableForQuery) {
        return new SelectQuery(tableForQuery);
    }
    
    /**
     * Create a new InsertQuery instance.
     */
    InsertQuery insert(Table tableForQuery) {
        return new InsertQuery(tableForQuery);
    }
    
    /**
     * Create a new UpdateQuery instance.
     */
    UpdateQuery update(Table tableForQuery) {
        return new UpdateQuery(tableForQuery);
    }
    
    /**
     * Create a new DeleteQuery instance.
     * Params:
     * \UIM\ORM\Table mytable The table this query is starting on.
     */
    DeleteQuery delete_(Table mytable) {
        return new DeleteQuery(mytable);
    }
}
