module uim.datasources.mixins.connection;

import uim.datasources;

@safe:

string datasourceConnectionThis(string name) {
    string fullName = name ~ "DatasourceConnection";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(string name) {
        super(); this.name(name);
    }
    `;
}

template DatasourceConnectionThis(string name) {
    const char[] DatasourceConnectionThis = datasourceConnectionThis(name);
}

string datasourceConnectionCalls(string name) {
    string fullName = name ~ "DatasourceConnection";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template DatasourceConnectionCalls(string name) {
    const char[] DatasourceConnectionCalls = datasourceConnectionCalls(name);
}