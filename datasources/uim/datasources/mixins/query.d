module uim.datasources.mixins.query;

import uim.datasources;

@safe:
string datasourceQueryThis(string name = null) {
    string fullName = name ~ "DatasourceQuery";
    return objThis(fullName);
}

template DatasourceQueryThis(string name = null) {
    const char[] DatasourceQueryThis = datasourceQueryThis(name);
}

string datasourceQueryCalls(string name) {
    string fullName = name ~ "DatasourceQuery";
    return objCalls(fullName);
}

template DatasourceQueryCalls(string name) {
    const char[] DatasourceQueryCalls = datasourceQueryCalls(name);
}
