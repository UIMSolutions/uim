module datasources.uim.datasources.mixins.entity;

import uim.datasources;

@safe:
string datasourceEntityThis(string name = null) {
    string fullName = name ~ "DatasourceEntity";
    return objThis(fullName);
}

template DatasourceEntityThis(string name = null) {
    const char[] DatasourceEntityThis = datasourceEntityThis(name);
}

string datasourceEntityCalls(string name) {
    string fullName = name ~ "DatasourceEntity";
    return objCalls(fullName);
}

template DatasourceEntityCalls(string name) {
    const char[] DatasourceEntityCalls = datasourceEntityCalls(name);
}
