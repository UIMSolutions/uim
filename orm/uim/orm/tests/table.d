module uim.orm.tests.table;

import uim.orm;

@safe:

bool testTable(IORMTable table) {
    assert(table !is null, "In testTable: table is null");
    
    return true;
}