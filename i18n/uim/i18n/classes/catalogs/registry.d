module uim.i18n.classes.catalogs.registry;

import uim.i18n;

@safe:

class DMessageCatalogRegistry : DObjectRegistry!DMessageCatalog {
}

auto MessageCatalogRegistry() {
    return DMessageCatalogRegistry.registry;
}