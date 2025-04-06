module uim.datasources.classes.repositories.repository;

mixin(Version!"test_uim_datasources");

import uim.datasources;
@safe:

class DDatasourceRepository : UIMObject, IDatasourceRepository {
    mixin(DatasourceRepositoryThis!());
}

unittest {
    // TODO
}