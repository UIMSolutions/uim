module uim.orm.classes.queries.insert;

import uim.orm;

@safe:

class DInsertQuery : DQuery {
    /*
    mixin CommonQueryTemplate();

    this(Table table) {
        super(table.getConnection());

        this.setRepository(table);
        this.addDefaultTypes(table);
    }
 
    string sql(ValueBinder mybinder = null) {
        if (isEmpty(_parts["into"])) {
            myrepository = this.getRepository();
            this.into(myrepository.getTable());
        }
        return super.sql(mybinder);
    } */
}
