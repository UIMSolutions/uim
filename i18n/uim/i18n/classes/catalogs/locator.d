module uim.i18n.classes.catalogs.locator;

import uim.i18n;

@safe:

// A ServiceLocator implementation for loading and retaining catalog objects.
class DCatalogLocator {
   mixin TConfigurable;
  // Initialization
  bool initialize(Json[string] initData = null) {
    configuration(MemoryConfiguration);
    configuration.data(initData);
    
    return true;
  }
  /**
     * A registry of catalogs.
     *
     * This registry is two layers deep. The first key is a catalog name, the second key is a locale code, 
     * and the value is a callable that returns a catalog object for that name and locale.
     */
  protected ICatalog[string][string] registry;

  this(ICatalog[string][string] registry = null) {
    foreach (name, locales; registry) {
      locales.byKeyValue
        .each!(localeSpec => set(name, localeSpec.key, localeSpec.value));
    }
  }

  // Sets a catalog.
  void set(string catalogName, string catalogLocale, ICatalog catalog) {
    // TODO _registry[catalogName][catalogLocale] = catalog;
  }

  // Gets a Catalog object.
  ICatalog get(string catalogName, string catalogLocale) {
    /* if (!hasCatalog(catalogName)) {
      throw new DI18nException(
        "Catalog `%s` is not registered."
          .format(catalogName));
    } */
    if (!hasCatalog(catalogName, catalogLocale)) {
      throw new DI18nException(
        "Catalog `%s` with locale `%s` is not registered."
          .format(catalogName, catalogLocale));
    } 

    /* return _registry[catalogName][catalogLocale];  */
    return null; 
  }

  // Check if a Catalog object for given name and locale exists in registry.
  bool hasCatalog(string catalogName, string catalogLocale = null) {
    /* return _registry.hasKey(catalogName)
      ? (catalogLocale.isEmpty
          ? true : this.registry[catalogName].hasKey(catalogLocale)) : false;
    */
    return false;
  }
}
