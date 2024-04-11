module uim.orm.classes.queries.insert;

import uim.orm;

@safe:

class DInsertQuery : DQuery {
    /*
    mixin CommonTQuery();

    this(Table table) {
        super(table.getConnection());

        this.setRepository(table);
        this.addDefaultTypes(table);
    }
 
    string sql(DValueBinder mybinder = null) {
        if (isEmpty(_parts["into"])) {
            myrepository = this.getRepository();
            this.into(myrepository.getTable());
        }
        return super.sql(mybinder);
    } */
}
