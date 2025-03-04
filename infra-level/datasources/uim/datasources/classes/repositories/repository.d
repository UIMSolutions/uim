module uim.datasources.classes.repositories.repository;

import uim.datasources;

@safe:

class DDatasourceRepository : UIMObject, IDatasourceRepository {
    mixin(DatasourceRepositoryThis!());
}

unittest {
    // TODO
}