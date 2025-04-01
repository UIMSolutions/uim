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

  // #region entries
    protected Json[string] _entries;
    override Json[string] entries() {
      return _entries;
    }
    override IConfiguration entries(Json[string] newEntries) {
      _entries = newEntries;
      return this;
    }
 // #endregion entries

  // #region keys
  override string[] entryKeys() {
    return _entries.keys;
  }
  // #endregion keys

  // #region values
  override Json[] entryValues() {
    return _entries.values;
  }
  // #endregion values
  
  // #region has
    override bool hasEntry(string key) {
      return _entries.hasKey(key);
    }
      
    alias hasEntryValue = DConfiguration.hasEntryValue;
    override bool hasEntryValue(Json value) {
      return _entries.values.any!(v => v == value);
    }
  // #endregion has

  // #region get
    override Json getEntry(string key) {
      if (key.length == 0) {
        return Json(null);
      }

      return _entries.get(key, Json(null));
    }

    unittest {
      auto config = MemoryConfiguration;
      // TODO
    }
  // #endregion get

  // #region set
    alias setEntry = DConfiguration.setEntry;
    override IConfiguration setEntry(string key, Json value) {
      if (key.length == 0) {
        return this;
      }

      _entries[key] = value;
      return this;
    }

    unittest{
      auto config = MemoryConfiguration;

      // TODO 
    }
  // #endregion set

  // #endregion remove
    override IConfiguration removeEntry(string key) {
      if (key.length == 0) {
        return this;
      }

      _entries.remove(key);
      return this;
    }

    unittest {
      auto config = MemoryConfiguration;
      // TODO
    }
  // #endregion remove

  // #region clone
  override IConfiguration clone() {
    return MemoryConfiguration
      .entries(entries());
  }

  unittest {
    auto config = MemoryConfiguration;
/*     config.setEntry("a", Json("A"));
    config.setEntry("b", Json("B"));
    auto clonedConfig = config.clone;
    assert(clonedConfig.hasDefault("a") && clonedConfig.hasEntry("b"));
    assert(clonedConfig.getDefault("a") == Json("A") && clonedConfig.getEntry("b") == json("B")); */
  }
  // #endregion clone
}

mixin(ConfigurationCalls!("Memory"));

unittest {
  auto configuration = MemoryConfiguration;
  testConfiguration(MemoryConfiguration);
}
