module uim.i18n.classes.catalogs.registry;

import uim.i18n;

@safe:

class DCatalogRegistry : DObjectRegistry!DMessageCatalog {
    static DCatalogRegistry registry;
}

auto CatalogRegistry() {
    return DCatalogRegistry.registry;
}