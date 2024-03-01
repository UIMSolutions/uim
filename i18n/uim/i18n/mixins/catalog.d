module uim.i18n.mixins.catalog;

string catalogThis(string name) {
    string fullName = name ~ "Catalog";
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

template CatalogThis(string name) {
    const char[] CatalogThis = catalogThis(name);
}

string catalogCalls(string name) {
    string fullName = name ~ "Catalog";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template CatalogCalls(string name) {
    const char[] CatalogCalls = catalogCalls(name);
}