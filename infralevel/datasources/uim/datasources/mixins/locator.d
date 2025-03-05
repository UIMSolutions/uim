module uim.datasources.mixins.locator;

import uim.datasources;

@safe:
string datasourceLocatorThis(string name = null) {
    string fullName = name ~ "DatasourceLocator";
    return objThis(fullName);
}

template DatasourceLocatorThis(string name = null) {
    const char[] DatasourceLocatorThis = datasourceLocatorThis(name);
}

string datasourceLocatorCalls(string name) {
    string fullName = name ~ "DatasourceLocator";
    return objCalls(fullName);
}

template DatasourceLocatorCalls(string name) {
    const char[] DatasourceLocatorCalls = datasourceLocatorCalls(name);
}
