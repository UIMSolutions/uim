module uim.orm.classes.queries.insert;

import uim.orm;

@safe:

class DInsertQuery : DQuery {
    mixin TCommonQuery;

    this(DTTable table) {
        super(table.getConnection());

        setRepository(table);
        this.addDefaultTypes(table);
    }
 
    string sql(DValueBinder mybinder = null) {
        if (isEmpty(_parts["into"])) {
            myrepository = getRepository();
            this.into(myrepository.getTable());
        }
        return super.sql(mybinder);
    }
}
