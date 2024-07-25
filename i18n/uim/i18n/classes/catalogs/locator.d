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
  

  this(ICatalog[string][string] catalogs = null) {
    this.set(catalogs);
  }

  // #region catalogs
  // 2-dim Array  of catalogs. The first key is a catalog name, the second key is a locale code 
  protected ICatalog[string][string] _catalogs;

  // #region set
  // Sets a catalog.
  void set(ICatalog[string][string] catalogs) {
    catalogs.byKeyValue.each!(item => set(item.key, item.value));
  }

  void set(string catalogName, ICatalog[string] localCatalogs) {
    localCatalogs.byKeyValue.each!(item => set(catalogName, item.key, item.value));
  }

  void set(string catalogName, string catalogLocale, ICatalog catalog) {
    if (!hasKey(catalogName)) {
      set(catalogName, [catalogLocale: catalog]);
    }

    _catalogs[catalogName][catalogLocale] = catalog;
  }
  // #endregion set

  // Gets a Catalog object.
  ICatalog get(string catalogName, string catalogLocale) {
    if (!hasCatalog(catalogName)) {
      throw new DI18nException(
        "Catalog `%s` is not registered."
          .format(catalogName));
    }

    if (!hasCatalog(catalogName, catalogLocale)) {
      throw new DI18nException(
        "Catalog `%s` with locale `%s` is not registered."
          .format(catalogName, catalogLocale));
    } 

    return _catalogs[catalogName][catalogLocale]; 
  }

  ICatalog[string] get(string catalogName) {
    if (!hasCatalog(catalogName)) {
      throw new DI18nException(
        "Catalog `%s` is not registered.".format(catalogName));
    }

    return _catalogs[catalogName];
  }

  // Check if a Catalog object for given name and locale exists in registry.
  bool hasCatalog(string catalogName, string catalogLocale = null) {
    if (!_catalogs.hasKey(catalogName)) {
      return false;
    }

    if (catalogLocale.length == 0) {
      return true;
    }

    return _catalogs[catalogName].hasKey(catalogLocale);
  }
  // #endregion catalogs
}
