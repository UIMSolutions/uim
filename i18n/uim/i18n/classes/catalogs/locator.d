/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.i18n.classes.catalogs.locator;

import uim.i18n;

@safe:

// A ServiceLocator implementation for loading and retaining catalog objects.
class DMesseCatalogLocator : UIMObject {
  this() {
    super();
  }

  this(IMessageCatalog[string][string] catalogs = null) {
    this.set(catalogs);
  }

  // #region catalogs
  // The first key is a catalog name, the second key is a locale code 
  protected IMessageCatalog[string][string] _catalogs;
  IMessageCatalog[string][string] catalogs() {
    return _catalogs.dup;
  }

  void catalogs(IMessageCatalog[string][string] newCatalogs) {
    _catalogs = newCatalogs.dup;
  }

  // #region set
  // Sets a catalog.
  void set(IMessageCatalog[string][string] catalogs) {
    catalogs.byKeyValue.each!(item => set(item.key, item.value));
  }

  void set(string catalogName, IMessageCatalog[string] localCatalogs) {
    localCatalogs.byKeyValue.each!(item => set(catalogName, item.key, item.value));
  }

  void set(string catalogName, string catalogLocale, IMessageCatalog catalog) {
    if (!_catalogs.hasKey(catalogName)) {
      set(catalogName, [catalogLocale: catalog]);
    }

    _catalogs[catalogName][catalogLocale] = catalog;
  }
  // #endregion set

  // #region get
  // Gets a Catalog object.
  IMessageCatalog get(string catalogName, string catalogLocale) {
    if (!hasCatalog(catalogName)) {
      throw new DI18nException(format!"Catalog `%s` is not registered."(catalogName));
    }

    if (!hasCatalog(catalogName, catalogLocale)) {
      throw new DI18nException(format!"Catalog `%s` with locale `%s` is not registered."(catalogName, catalogLocale));
    }

    return _catalogs[catalogName][catalogLocale];
  }

  IMessageCatalog[string] get(string catalogName) {
    if (!hasCatalog(catalogName)) {
      throw new DI18nException(format!"Catalog `%s` is not registered."(catalogName));
    }

    return _catalogs[catalogName];
  }

  unittest {
    // TODO
  }
  // #endregion get

  // #region has
  // #region hasCatalog
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

  unittest {
    // TODO
  }
  // #endregion hasCatalog
  // #endregion has
  // #endregion catalogs
}
