module uim.datasources.classes.datasources.datasource;

mixin(Version!"test_uim_datasources");

import uim.datasources;
@safe:

class DDatasource : UIMObject, IDatasource {
    mixin(DatasourceThis!());
}

unittest {
    // TODO
}