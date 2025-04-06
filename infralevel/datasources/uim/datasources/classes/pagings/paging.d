module uim.datasources.classes.pagings.paging;

mixin(Version!"test_uim_datasources");

import uim.datasources;
@safe:

class DDatasourcePaging : UIMObject, IDatasourcePaging {
    mixin(DatasourcePagingThis!());
}

unittest {
    // TODO
}