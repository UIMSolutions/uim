module uim.datasources.mixins.resultset;

import uim.datasources;

@safe:
string datasourceResultsetThis(string name = null) {
    string fullName = name ~ "DatasourceResultset";
    return objThis(fullName);
}

template DatasourceResultsetThis(string name = null) {
    const char[] DatasourceResultsetThis = datasourceResultsetThis(name);
}

string datasourceResultsetCalls(string name) {
    string fullName = name ~ "DatasourceResultset";
    return objCalls(fullName);
}

template DatasourceResultsetCalls(string name) {
    const char[] DatasourceResultsetCalls = datasourceResultsetCalls(name);
}
