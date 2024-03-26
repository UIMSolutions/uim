module uim.datasources.mixins.datasourceentity;

string datasourceentityThis(string name) {
    string fullName = name ~ "DatasourceEntity";
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

template DatasourceEntityThis(string name) {
    const char[] DatasourceEntityThis = datasourceentityThis(name);
}

string datasourceEntityCalls(string name) {
    string fullName = name ~ "DatasourceEntity";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template DatasourceEntityCalls(string name) {
    const char[] DatasourceEntityCalls = datasourceEntityCalls(name);
}
