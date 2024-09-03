module uim.i18n.mixins.catalog;

string catalogThis(string name = null) {
    string fullName = name ~ "Catalog";
    return `
    this() {
        super("`~ fullName ~ `");
    }
    this(Json[string] initData) {
        super("`~ fullName ~ `", initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    `;
}

template CatalogThis(string name = null) {
    const char[] CatalogThis = catalogThis(name);
}

string catalogCalls(string name) {
    string fullName = name ~ "Catalog";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template CatalogCalls(string name) {
    const char[] CatalogCalls = catalogCalls(name);
}