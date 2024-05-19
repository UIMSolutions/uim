module uim.orm.classes.queries.delete_;

import uim.orm;

@safe:

class DeleteQuery : DQuery {
    /*
    mixin TCommonQuery();

    this(DTable mytable) {
        super(table.getConnection());

        setRepository(table);
        this.addDefaultTypes(table);
    }
 
    string sql(DValueBinder mybinder = null) {
        if (isEmpty(_parts["from"])) {
            myrepository = getRepository();
            this.from([myrepository.aliasName(): myrepository.getTable()]);
        }
        return super.sql(mybinder);
    }
}
