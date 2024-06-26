module uim.orm.classes.queries.update;

import uim.orm;

@safe:

class DUpdateQuery : DQuery {
    // mixin TCommonQuery();

    /**
     
     * Params:
     * \ORM\Table mytable The table this query is starting on
     */
    this(DTTable aTable) {
        super(aTable.getConnection());

        setRepository(aTable);
        this.addDefaultTypes(aTable);
    }
 
    string sql(DValueBinder mybinder = null) {
        if (!_parts.hasKey("update") || _parts["update"].isEmpty) {
            myrepository = getRepository();
            this.update(myrepository.getTable());
        }
        return super.sql(mybinder);
    }
}
