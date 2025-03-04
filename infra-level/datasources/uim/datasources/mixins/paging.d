module uim.datasources.mixins.paging;

import uim.datasources;

@safe:
string datasourcePagingThis(string name = null) {
    string fullName = name ~ "DatasourcePaging";
    return objThis(fullName);
}

template DatasourcePagingThis(string name = null) {
    const char[] DatasourcePagingThis = datasourcePagingThis(name);
}

string datasourcePagingCalls(string name) {
    string fullName = name ~ "DatasourcePaging";
    return objCalls(fullName);
}

template DatasourcePagingCalls(string name) {
    const char[] DatasourcePagingCalls = datasourcePagingCalls(name);
}
