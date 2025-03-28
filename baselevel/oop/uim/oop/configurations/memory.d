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

  // #region defaults
    protected Json[string] _defaults;
    override Json[string] defaults() {
      return _defaults.dup;
    }

    override IConfiguration defaults(Json[string] items) {
      _defaults = items.dup;
      return this;
    }
  // #endregion defaults

  // #region entries
    alias entries = DConfiguration.entries;
    protected Json[string] _entries;
    override Json[string] entries() {
      return _entries.dup;
    }

    override IConfiguration entries(Json[string] items) {
      _entries = items.dup;
      return this;
    }
  // #endregion entries

  // #region hasDefault
    override bool hasDefault(string key) {
      return _defaults.hasKey(key);
    }
  // #endregion hasDefault

  // #region default_
    override Json default_(string key) {
      return _defaults.get(key, Json(null));
    }
  // #endregion default_

  // #region hasEntry
    override bool hasEntry(string key) {
      return _entries.hasKey(key);
    }
  // #endregion hasEntry

  // #region hasValue
    alias hasDefaultValue = DConfiguration.hasDefaultValue;
    override bool hasDefaultValue(Json value) {
      return defaultValues.any!(v => v == value);
    }

    alias hasEntryValue = DConfiguration.hasEntryValue;
    override bool hasEntryValue(Json value) {
      return entryValues.any!(v => v == value);
    }

    unittest {
      auto config = MemoryConfiguration;

      config.setDefault("a", Json("A"));
      config.setDefault("b", Json("B"));
      assert(config.hasDefaultValue(Json("A")));

      config.setEntry("c", Json("C"));
      config.setEntry("d", Json("D"));      
      assert(config.hasEntryValue(Json("D")));

      config.setDefault("e", Json("E"));
      config.setEntry("f", Json("F"));      
      assert(config.hasDefaultValue(Json("E")) && config.hasValue(Json("E")) && config.hasEntryValue(Json("F")) && config.hasValue(Json("F")));
    }
  // #endregion hasValue

  // #region values
    override Json[] defaultValues(string[] keys = null)  {
      return keys.length == 0
        ? _defaults.values : keys
        .filter!(key => hasDefault(key))
        .map!(key => default_(key))
        .array;
    }

    override Json[] entryValues(string[] keys = null) {
      return keys.length == 0
        ? _entries.values : keys
        .filter!(key => hasEntry(key))
        .map!(key => entry(key))
        .array;
    }
  // #endregion values

  // #region keys
  override string[] keys() {
    return _entries.keys;
  }
  // #endregion keys

  // #region get
  override Json entry(string key) {
    if (key.length == 0) {
      return Json(null);
    }

    return _entries.get(key, default_(key));
  }
  // #endregion get

  // #region defaults
    // #region set
      alias setDefault = DConfiguration.setDefault;
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
      alias setEntry = DConfiguration.setEntry;
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

  
  // #region clone
  override IConfiguration clone() {
    return MemoryConfiguration
      .defaults(defaults())
      .entries(entries());
  }

  unittest {
    auto config = MemoryConfiguration;
/*     config.setDefault("a", Json("A"));
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
  writeln("DMemoryConfiguration::membernames() -> ", configuration.memberNames);
  testConfiguration(MemoryConfiguration);
}
