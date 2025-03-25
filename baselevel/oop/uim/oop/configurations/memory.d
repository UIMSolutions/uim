/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.configurations.memory;

mixin(Version!"test_uim_oop");

import uim.oop;
@safe:

class DMemoryConfiguration : DConfiguration {
  mixin(ConfigurationThis!("Memory"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  // #region defaultEntries
  protected Json[string] _defaultEntries;
  override Json[string] defaultEntries() {
    return _defaultEntries.dup;
  }

  override IConfiguration defaultEntries(Json[string] newValue) {
    _defaultEntries = newValue.dup;
    return this;
  }
  // #endregion defaultEntries

  // override bool hasDefault(string key)
  override bool hasDefault(string key) {
    return (key in _defaultEntries) ? true : false;
  }

  override Json getDefault(string key) {
    return (key in _defaultEntries) ? _defaultEntries[key] : Json(null);
  }

  // #region data
  // Set and get data
  protected Json[string] _entries;

  override Json[string] data() {
    return _entries.dup;
  }

  override void data(Json[string] newData) {
    _entries = newData.dup;
  }
  // #endregion data

  // #region key
  alias hasAnyKeys = DConfiguration.hasAnyKeys;
  override bool hasAnyKeys(string[] keys) {
    return keys.any!(key => hasKey(key));
  }

  alias hasAllKeys = DConfiguration.hasAllKeys;
  override bool hasAllKeys(string[] keys) {
    return keys.all!(key => hasKey(key));
  }

  override bool hasKey(string key) {
    return (key in _entries) || hasDefault(key) ? true : false;
  }
  // #endregion key

  // #region value
  alias hasAnyValues = DConfiguration.hasAnyValues;
  override bool hasAnyValues(Json[] values) {
    return values.any!(value => hasValue(value));
  }

  alias hasAllValues = DConfiguration.hasAllValues;
  override bool hasAllValues(Json[] values) {
    return values.all!(value => hasValue(value));
  }

  override bool hasValue(Json value) {
    return _entries.byKeyValue
      .any!(kv => kv.value == value);
  }

  override Json[] values(string[] includedKeys = null) {
    return includedKeys.length == 0
      ? _entries.values : includedKeys
      .filter!(key => hasKey(key))
      .map!(key => get(key))
      .array;
  }
  // #endregion value

  override string[] keys() {
    return _entries.keys;
  }

  // #region get
  override Json[string] get(string[] selectKeys, bool compressMode = true) {
    Json[string] results;

    selectKeys.each!((key) {
      Json result = get(key);
      if (result is Json(null) && !compressMode) {
        results[key] = result;
      }
    });

    return results;
  }

  override Json get(string key, Json defaultValue = Json(null)) {
    if (key.length == 0) {
      return Json(null);
    }

    if (key in _entries) {
      return _entries[key];
    }

    return defaultValue.isNull
      ? getDefault(key) : defaultValue;
  }
  // #endregion get

  // #region defaults
    // #region set
      override IConfiguration setDefault(string key, bool value) {
        setDefault(key, value.toJson);
        return this;
      }

      override IConfiguration setDefault(string key, long value) {
        setDefault(key, value.toJson);
        return this;
      }

      override IConfiguration setDefault(string key, double value) {
        setDefault(key, value.toJson);
        return this;
      }

      override IConfiguration setDefault(string key, string value) {
        setDefault(key, value.toJson);
        return this;
      }

      override IConfiguration setDefault(string key, Json[] value) {
        setDefault(key, value.toJson);
        return this;
      }

      override IConfiguration setDefault(string key, Json[string] value) {
        setDefault(key, value.toJson);
        return this;
      }
      
      override IConfiguration setDefault(string key, Json value) {
        _defaults[key] = value;
        return this;
      }
    // #endregion set

    // #region remove
      override IConfiguration removeDefault(string key) {
        _defaults.remove(key);
        return this;
      }

      unittest {
        // TODO
      }
    // #endregion remove
  // #endregion defaults

  // #region entries
    // #region set
      override IConfiguration setEntry(string key, bool value) {
        setEntry(key, value.toJson);
        return this;
      }

      override IConfiguration setEntry(string key, long value) {
        setEntry(key, value.toJson);
        return this;
      }

      override IConfiguration setEntry(string key, double value) {
        setEntry(key, value.toJson);
        return this;
      }

      override IConfiguration setEntry(string key, string value) {
        setEntry(key, value.toJson);
        return this;
      }

      override IConfiguration setEntry(string key, Json[] value) {
        setEntry(key, value.toJson);
        return this;
      }

      override IConfiguration setEntry(string key, Json[string] value) {
        setEntry(key, value.toJson);
        return this;
      }
      
      override IConfiguration setEntry(string key, Json value) {
        _entries[key] = value;
        return this;
      }
    // #endregion set

    // #region remove
      alias removeEntry = DConfiguration.removeEntry;
      override IConfiguration removeEntry(string key) {
        _entries.remove(key);
        return this;
      }

      unittest {
        // TODO
      }
    // #endregion remove
  // #endregion entries

  

  override IConfiguration clone() {
    return MemoryConfiguration;
    // TODO 
  }

}

mixin(ConfigurationCalls!("Memory"));

unittest {
  auto configuration = MemoryConfiguration;
  writeln("DMemoryConfiguration::membernames() -> ", configuration.memberNames);
  testConfiguration(MemoryConfiguration);
}
