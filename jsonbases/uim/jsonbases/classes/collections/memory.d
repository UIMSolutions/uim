module uim.jsonbases.classes.collections.memory;

import uim.jsonbases;

unittest {
  version (testUimJsonbase) {
    debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
  }
}

@safe:
class DMemoryJsonCollection : DJsonCollection {
  mixin(JsonCollectionThis!("MemoryJsonCollection"));

  protected Json[size_t][UUID] _items;

  alias findMany = DJsonCollection.findMany;
  /// Find all (many) items in a collection. allVersions:false = find last versions, allVersion:true = find all versions
  override Json[] findMany(bool allVersions = false) {
    Json[] results;

    if (auto Ids = _items.byKey.array) {
      foreach (id; Ids) {
        auto itemsId = _items[id];
        if (!itemsId.empty) {
          results ~= allVersions ? itemsId.byValue.array : [
            lastVersion(itemsId)
          ];
        }
      }
    }

    return results;
  }

  version (test_uim_jsonbase) {
    unittest {

      auto col = MemoryJsonCollection;
      assert(test_findMany(col));
      assert(test_findMany_allVersions(col));
    }
  }

  /// Find all (many) items in a collection with id. allVersions:false = find last version, allVersion:true = find all versions
  override Json[] findMany(UUID id, bool allVersions = false) {
    Json[] results;

    if (auto item = _items.get(id, null)) {
      if (!item.empty)
        results = allVersions ? item.byValue.array : [lastVersion(item)];
    }

    return results;
  }

  version (test_uim_jsonbase) {
    unittest {

      auto col = MemoryJsonCollection;
      assert(test_findMany_id(col));
      assert(test_findMany_id_allVersions(col));
    }
  }

  override Json[] findMany(STRINGAA select, bool allVersions = false) {
    Json[] results;

    if (auto items = findMany(allVersions)) {
      foreach (item; items) {
        if (checkVersion(item, select))
          results ~= item;
      }
    }

    return results;
  }

  version (test_uim_jsonbase) {
    unittest {

      auto col = MemoryJsonCollection;
      assert(test_findMany_select(col));
      assert(test_findMany_select_allVersions(col));
    }
  }

  override Json[] findMany(Json select, bool allVersions = false) {
    Json[] results;

    if (auto items = findMany(allVersions)) {
      results = items
        .filter!(item => checkVersion(item, select))
        .map!(item => item)
        .array;
    }

    return results;
  }

  version (test_uim_jsonbase) {
    unittest {

      auto col = MemoryJsonCollection;
      assert(test_findMany_jselect(col));
      assert(test_findMany_jselect_allVersions(col));
    }
  }

  alias findOne = DJsonCollection.findOne;
  override Json findOne(UUID id, bool allVersions = false) {
    auto result = Json(null);

    if (auto item = _items.get(id, null)) {
      if (!item.empty)
        result = allVersions ? item.byValue.array[0] : lastVersion(item);
    }

    return result;
  }

  version (test_uim_jsonbase) {
    unittest {

      auto col = MemoryJsonCollection;
      assert(test_findOne_id(col));
      assert(test_findOne_id_allVersions(col));
    }
  }

  override Json findOne(UUID id, size_t versionNumber) {
    Json result = Json(null);

    if (auto item = _items.get(id, null) && versionNumber in item) {
      result = item[versionNumber];
    }

    return result;
  }

  version (test_uim_jsonbase) {
    unittest {

      auto col = MemoryJsonCollection;
      assert(test_findOne_id_versionNumber(col));
    }
  }

  override Json findOne(STRINGAA select, bool allVersions = false) {
    if (auto allItems = findMany(allVersions)) {
      foreach (oneItem; allItems)
        if (oneItem.checkVersion)
          return oneItem;
    }

    return Json(null);
  }

  version (test_uim_jsonbase) {
    unittest {

      auto col = MemoryJsonCollection;
      assert(test_findMany_select(col));
      assert(test_findMany_select_allVersions(col));
    }
  }

  override Json findOne(Json select, bool allVersions = false) {
    if (auto allItems = findMany(allVersions)) {
      foreach (oneItem; allItems)
        if (oneItem.checkVersion)
          return oneItem;
    }

    return Json(null);
  }

  version (test_uim_jsonbase) {
    unittest {

      auto col = MemoryJsonCollection;
      assert(test_findMany_jselect(col));
      assert(test_findMany_jselect_allVersions(col));
    }
  }

  override Json insertOne(Json newData) {
    if (newData.isEmpty)
      return Json(null);
    auto id = "id" in newData ? UUID(newData["id"].get!string) : randomUUID;
    auto versionNumber = "versionNumber" in newData ? newData["versionNumber"].get!size_t : 1UL;

    if (id !in _items)
      _items[id] = null;
    _items[id][versionNumber] = newData;

    return findOne(newData);
  }

  version (test_uim_jsonbase) {
    unittest {

      auto col = MemoryJsonCollection;
      assert(test_insertOne_data(col));
    }
  }

  override size_t updateMany(Json select, Json updateData) {
    size_t updates;
    foreach (id; _items.byKey) {
      foreach (vNumber; _items[id].byKey) {
        if (!checkVersion(_items[id][vNumber], select))
          continue;

        updates++;
        auto itemVersion = _items[id][vNumber];
        updateData.byKeyValue
          .filter!(kv => kv.key != "id" || kv.key != "versionNumber")
          .each!(kv => itemVersion[kv.key] = kv.value);

        _items[id][vNumber] = itemVersion;
      }
    }
    return updates;
  }

  version (test_uim_jsonbase) {
    unittest {

      auto col = MemoryJsonCollection;
      assert(test_updateMany_select_data(col));
    }
  }

  override bool updateOne(Json select, Json updateData) {
    foreach (id; _items.byKey) {
      foreach (vNumber; _items[id].byKey) {
        if (!checkVersion(_items[id][vNumber], select))
          continue;

        auto json = _items[id][vNumber];
        updateData.byKeyValue
          .filter!(kv => kv.key != "id" || kv.key != "versionNumber")
          .each!(kv => json[kv.key] = kv.value);

        _items[id][vNumber] = json;
        return true;
      }
    }
    return false;
  }

  version (test_uim_jsonbase) {
    unittest {

      auto col = MemoryJsonCollection;
      assert(test_updateOne_select_data(col));
    }
  }

  /// Remove items from collections
  alias removeMany = DJsonCollection.removeMany;
  /// Remove items from collectionsby it. allVersions:false - remove lastVersion, allVersion:true / allVersions (complete)
  override size_t removeMany(UUID id, bool allVersions = false) {
    size_t result = 0;
    if (id in _items) {
      auto itemsId = _items[id];
      if (allVersions) {
        result = itemsId.length;
        _items.remove(id);
      } else {
        auto lastVers = lastVersion(itemsId);
        itemsId.remove(lastVers["versionNumber"].get!size_t);
      }
    }
    return result;
  }

  version (test_uim_jsonbase) {
    unittest {

      auto col = MemoryJsonCollection;
      assert(test_removeMany_id(col));
      assert(test_removeMany_id_allVersions(col));
    }
  }

  override size_t removeMany(STRINGAA select, bool allVersions = false) {
    size_t counter;

    foreach (id, itemId; _items) {
      if (allVersions) {
        foreach (vNumber, item; itemId) {
          if (checkVersion(item, select)) {
            counter++;
            _items[id].remove(vNumber);
          }
        }
      } else {
        if (auto item = lastVersion(itemId)) {
          if (checkVersion(item, select)) {
            counter++;
            _items[id].remove(item["versionNumber"].get!size_t);
          }
        }
      }
      if (_items[id].empty)
        _items.remove(id);
    }

    return counter;
  }

  version (test_uim_jsonbase) {
    unittest {

      auto col = MemoryJsonCollection;
      assert(test_removeMany_select(col));
      assert(test_removeMany_select_allVersions(col));
    }
  }

  override size_t removeMany(Json select, bool allVersions = false) {
    size_t counter;

    foreach (id, itemId; _items) {
      if (allVersions) {
        foreach (vNumber, item; itemId) {
          if (checkVersion(item, select)) {
            counter++;
            _items[id].remove(vNumber);
          }
        }
      } else {
        if (auto item = lastVersion(itemId)) {
          if (checkVersion(item, select)) {
            counter++;
            _items[id].remove(item["versionNumber"].get!size_t);
          }
        }
      }
      if (_items[id].empty)
        _items.remove(id);
    }

    return counter;
  }

  version (test_uim_jsonbase) {
    unittest {

      auto col = MemoryJsonCollection;
      assert(test_removeMany_jselect(col));
      assert(test_removeMany_jselect_allVersions(col));
    }
  }

  /// Remove one item or one version from collection
  alias removeOne = DJsonCollection.removeOne;
  /// Remove based on id - allVersions:true - remove all, remove lastVersion 
  override bool removeOne(UUID id, bool allVersions = false) {
    if (id in _items) {
      if (allVersions) {
        _items.remove(id);
        return true;
      } else {
        foreach (vNumber; _items[id].byKey) {
          _items[id].remove(vNumber);
          return true;
        }
      }
    }
    return false;
  }

  version (test_uim_jsonbase) {
    unittest {

      auto col = MemoryJsonCollection;
      assert(test_removeOne_id(col));
      assert(test_removeOne_id_allVersions(col));
    }
  }

  override bool removeOne(UUID id, size_t versionNumber) {
    if (auto itemsId = _items.get(id, null)) {
      if (versionNumber in itemsId) {
        _items[id].remove(versionNumber);
        return true;
      }
    }
    return false;
  }

  version (test_uim_jsonbase) {
    unittest {

      auto col = MemoryJsonCollection;
      assert(test_removeOne_id_versionNumber(col));
    }
  }

  override bool removeOne(STRINGAA select, bool allVersions = false) {
    if (auto allItems = findMany(allVersions)) {
      foreach (oneItem; allItems) {
        if ("id" !in oneItem)
          continue;
        if ("versionNumber" !in oneItem)
          continue;

        if (checkVersion(oneItem, select)) {
          auto id = UUID(oneItem["id"].get!string);
          auto vNumber = oneItem["versionNUmber"].get!size_t;
          auto itemsId = _items[id];
          itemsId.remove(vNumber);
        }
      }
    }
    return false;
  }

  unittest {
    version (uim_jsonbase) {
      auto col = MemoryJsonCollection;
      assert(test_removeOne_select(col));
      assert(test_removeOne_select_allVersions(col));
    }
  }

  override bool removeOne(Json select, bool allVersions = false) {
    if (auto allItems = findMany(allVersions)) {
      foreach (oneItem; allItems)
        if (checkVersion(oneItem, select)) {
          if ("id" !in oneItem)
            continue;
          if ("versionNumber" !in oneItem)
            continue;

          if (checkVersion(oneItem, select)) {
            auto id = UUID(oneItem["id"].get!string);
            auto vNumber = oneItem["versionNUmber"].get!size_t;
            auto itemsId = _items[id];
            itemsId.remove(vNumber);
          }
        }
    }
    return false;
  }

  version (test_uim_jsonbase) {
    unittest {

      auto col = MemoryJsonCollection;
      assert(test_removeOne_jselect(col));
      assert(test_removeOne_jselect_allVersions(col));
    }
  }
}

mixin(JsonCollectionCalls!("MemoryJsonCollection"));

unittest {
  version (testUimJsonbase) {
    debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
  }
}
