module uim.databases.classes.queries.query;

import uim.databases;
@safe:

version (test_uim_databases) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DSQLQuery : UIMObject, ISQLQuery {
    mixin(SQLQueryThis!());
}