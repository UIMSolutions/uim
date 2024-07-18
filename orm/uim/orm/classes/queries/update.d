module uim.orm.classes.queries.update;

import uim.orm;

@safe:

class DUpdateQuery : DQuery {
    // mixin TCommonQuery();

    this(DORMTable aTable) {
        super(aTable.getConnection());

        setRepository(aTable);
        this.addDefaultTypes(aTable);
    }
 
    string sql(DValueBinder mybinder = null) {
        if (!_parts.hasKey("update") || _parts.isEmpty("update")) {
            updateKey(getRepository().getTable());
        }
        return super.sql(mybinder);
    }
}
