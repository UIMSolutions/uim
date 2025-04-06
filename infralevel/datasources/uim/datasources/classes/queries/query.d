module uim.datasources.classes.queries.query;

mixin(Version!"test_uim_datasources");

import uim.datasources;
@safe:

class DDatasourceQuery : UIMObject, IDatasourceQuery {
    mixin(DatasourceQueryThis!());
}

unittest {
    // TODO
}