module uim.orm.queries.delete_;

import uim.orm;

@safe:

class DeleteQuery : DbDeleteQuery {
    mixin CommonQueryTemplate();

    this(Table mytable) {
        super(table.getConnection());

        this.setRepository(table);
        this.addDefaultTypes(table);
    }
 
    string sql(ValueBinder mybinder = null) {
        if (isEmpty(_parts["from"])) {
            myrepository = this.getRepository();
            this.from([myrepository.aliasName(): myrepository.getTable()]);
        }
        return super.sql(mybinder);
    }
}
