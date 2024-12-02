module uim.datasources.mixins.repository;

import uim.datasources;

@safe:
string datasourceRepositoryThis(string name = null) {
    string fullName = name ~ "DatasourceRepository";
    return objThis(fullName);
}

template DatasourceRepositoryThis(string name = null) {
    const char[] DatasourceRepositoryThis = datasourceRepositoryThis(name);
}

string datasourcerepositoryCalls(string name) {
    string fullName = name ~ "DatasourceRepository";
    return objCalls(fullName);
}

template DatasourceRepositoryCalls(string name) {
    const char[] DatasourceRepositoryCalls = datasourceRepositoryCalls(name);
}
