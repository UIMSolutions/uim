module uim.orm.classes.queries.update;

import uim.orm;

@safe:

class DUpdateQuery : DQuery {
    // mixin CommonQueryTemplate();

    /**
     * Constructor
     * Params:
     * \UIM\ORM\Table mytable The table this query is starting on
     * /
    this(Table aTable) {
        super(aTable.getConnection());

        this.setRepository(aTable);
        this.addDefaultTypes(aTable);
    }
 
    string sql(ValueBinder mybinder = null) {
        if (!_parts.isSet("update") || _parts["update"].isEmpty) {
            myrepository = this.getRepository();
            this.update(myrepository.getTable());
        }
        return super.sql(mybinder);
    } */
}
