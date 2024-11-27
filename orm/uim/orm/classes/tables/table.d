module uim.orm.classes.tables.table;

import uim.orm;
@safe:

class DORMTable : UIMObject, IORMTable {
    mixin(ORMTableThis!());
}