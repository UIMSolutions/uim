module uim.orm.mixins.commonquery;

import uim.orm;

@safe:

// mixin template with common methods used by all ORM query classes.
mixin template TCommonQuery() {
    /**
     * Hints this object to associate the correct types when casting conditions
     * for the database. This is done by extracting the field types from the schema
     * associated to the passed table object. This prevents the user from repeating
     * themselves when specifying conditions.
     *
     * This method returns the same query object for chaining.
     * Params:
     * \ORM\Table mytable The table to pull types from
     */
    void addDefaultTypes(Table mytable) {
        auto aliasName = mytable.aliasName();
        auto mymap = mytable.getSchema().typeMap();
        auto fieldNames = null;
        mymap.byKeyValue.each!((kv) {
            fieldNames[kv.key] = kv.value; 
            fieldNames[aliasName ~ "." ~ kv.key] = kv.value;
            fieldNames[aliasName ~ "__" ~ kv.key] = kv.value;
        });
        getTypeMap().addDefaults(fieldNames);
    }
    
    // Instance of a repository/table object this query is bound to.
    // protected ITable _repository;

    /**
     * Set the default Table object that will be used by this query
     * and form the `FROM` clause.
     * Params:
     * \UIM\Datasource\IRepository myrepository The default table object to use
     */
    void setRepository(IRepository myrepository) {
        assert(
            cast(Table)myrepository,
            "`myrepository` must be an instance of `" ~ Table.classname ~ "`."
        );

       _repository = myrepository;
    }
    
    /**
     * Returns the default repository object that will be used by this query,
     * that is, the table that will appear in the from clause.
     */
    Table getRepository() {
        return _repository;
    } */
}
