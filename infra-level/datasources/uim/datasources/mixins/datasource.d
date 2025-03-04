module uim.datasources.mixins.datasource;

import uim.datasources;

@safe:
string datasourceThis(string name = null) {
    string fullName = name ~ "Datasource";
    return objThis(fullName);
}

template DatasourceThis(string name = null) {
    const char[] DatasourceThis = datasourceThis(name);
}

string datasourceCalls(string name) {
    string fullName = name ~ "Datasource";
    return objCalls(fullName);
}

template DatasourceCalls(string name) {
    const char[] DatasourceCalls = datasourceCalls(name);
}
