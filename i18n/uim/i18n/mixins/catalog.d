module uim.i18n.mixins.catalog;

string catalogThis(string name = null) {
    string fullName = `"` ~ name ~ "Catalog"~`"`;
    return objThis(fullName);
}

template CatalogThis(string name = null) {
    const char[] CatalogThis = catalogThis(name);
}

string catalogCalls(string name) {
    string fullName = name ~ "Catalog";
    return objCalls(fullName);
}

template CatalogCalls(string name) {
    const char[] CatalogCalls = catalogCalls(name);
}