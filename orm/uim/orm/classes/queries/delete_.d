module uim.orm.classes.queries.delete_;

import uim.orm;

@safe:

class DeleteQuery : DQuery {
    /*
    mixin CommonTQuery();

    this(Table mytable) {
        super(table.getConnection());

        this.setRepository(table);
        this.addDefaultTypes(table);
    }
 
    string sql(DValueBinder mybinder = null) {
        if (isEmpty(_parts["from"])) {
            myrepository = this.getRepository();
            this.from([myrepository.aliasName(): myrepository.getTable()]);
        }
        return super.sql(mybinder);
    } */
}
