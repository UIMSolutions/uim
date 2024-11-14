module uim.datasources.mixins.connection;

import uim.datasources;

@safe:
string datasourceConnectionThis(string name = null) {
    string fullName = name ~ "DatasourceConnection";
    return objThis(fullName);
}

template DatasourceConnectionThis(string name = null) {
    const char[] DatasourceConnectionThis = datasourceConnectionThis(name);
}

string datasourceconnectionCalls(string name) {
    string fullName = name ~ "DatasourceConnection";
    return objCalls(fullName);
}

template DatasourceConnectionCalls(string name) {
    const char[] DatasourceConnectionCalls = datasourceConnectionCalls(name);
}
