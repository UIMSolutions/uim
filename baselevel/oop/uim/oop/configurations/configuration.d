/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.configurations.configuration;

mixin(Version!"test_uim_oop");

import uim.oop;
@safe:

/* private alias KeyValue = Tuple!(string, "key", Json, "value");
@property auto byKeyValue(Json[string] data)
@trusted {
  return data.byKeyValue.map!(kv => KeyValue(kv.key, kv.value)).array;
} */

// Configuration for handling config data = key: string / value: Json
class DConfiguration : UIMObject, IConfiguration {
  mixin(ConfigurationThis!());

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  // #region defaults
  abstract Json[string] defaults();
  abstract IConfiguration defaults(Json[string] newData);
  // #endregion defaults

  // #region entries
    abstract Json[string] entries();
    abstract IConfiguration entries(Json[string] newData);
 // #endregion entries

  // #region has
    // #region defaults
      mixin(HasAction!("Defaults", "Default", "string"));
      abstract bool hasDefault(string key);
    // #endregion defaults

    // #region entries
      mixin(HasAction!("Entries", "Entry", "string"));
      
      abstract bool hasEntry(string key);
    // #endregion entries
  // #endregion has

  // #region hasValue
    // #region defaults
      mixin(HasAction!("DefaultValues", "DefaultValue", "bool"));
      mixin(HasAction!("DefaultValues", "DefaultValue", "long"));
      mixin(HasAction!("DefaultValues", "DefaultValue", "double"));
      mixin(HasAction!("DefaultValues", "DefaultValue", "string"));
      mixin(HasAction!("DefaultValues", "DefaultValue", "Json[]"));
      mixin(HasAction!("DefaultValues", "DefaultValue", "Json[string]"));
      mixin(HasAction!("DefaultValues", "DefaultValue", "Json"));
      
      bool hasDefaultValue(bool value) {
        return hasDefaultValue(value.toJson);
      }

      bool hasDefaultValue(long value) {
        return hasDefaultValue(value.toJson);
      }

      bool hasDefaultValue(double value) {
        return hasDefaultValue(value.toJson);
      }

      bool hasDefaultValue(string value) {
        return hasDefaultValue(value.toJson);
      }

      bool hasDefaultValue(Json[] value) {
        return hasDefaultValue(value.toJson);
      }

      bool hasDefaultValue(Json[string] value) {
        return hasDefaultValue(value.toJson);
      }

      abstract bool hasDefaultValue(Json value);

      unittest {
        auto config = MemoryConfiguration;
        // TODO
      }
    // #endregion defaults

    // #region entries
      mixin(HasAction!("EntryValues", "EntryValue", "bool"));
      mixin(HasAction!("EntryValues", "EntryValue", "long"));
      mixin(HasAction!("EntryValues", "EntryValue", "double"));
      mixin(HasAction!("EntryValues", "EntryValue", "string"));
      mixin(HasAction!("EntryValues", "EntryValue", "Json[]"));
      mixin(HasAction!("EntryValues", "EntryValue", "Json[string]"));
      mixin(HasAction!("EntryValues", "EntryValue", "Json"));
      
      bool hasEntryValue(bool value) {
        return hasEntryValue(value.toJson);
      }

      bool hasEntryValue(long value) {
        return hasEntryValue(value.toJson);
      }

      bool hasEntryValue(double value) {
        return hasEntryValue(value.toJson);
      }

      bool hasEntryValue(string value) {
        return hasEntryValue(value.toJson);
      }

      bool hasEntryValue(Json[] value) {
        return hasEntryValue(value.toJson);
      }

      bool hasEntryValue(Json[string] value) {
        return hasEntryValue(value.toJson);
      }

      abstract bool hasEntryValue(Json value);
      
      unittest {
        auto config = MemoryConfiguration;

        // TODO
      }
    // #endregion entries

    // #region values
      mixin(HasAction!("Values", "Value", "bool"));
      mixin(HasAction!("Values", "Value", "long"));
      mixin(HasAction!("Values", "Value", "double"));
      mixin(HasAction!("Values", "Value", "string"));
      mixin(HasAction!("Values", "Value", "Json[]"));
      mixin(HasAction!("Values", "Value", "Json[string]"));

      bool hasValue(bool value) {
        return hasEntryValue(value) 
          ? true
          : hasDefaultValue(value);
      }

      bool hasValue(long value) {
        return hasEntryValue(value) 
          ? true
          : hasDefaultValue(value);
      }

      bool hasValue(double value) {
        return hasEntryValue(value) 
          ? true
          : hasDefaultValue(value);
      }

      bool hasValue(string value) {
        return hasEntryValue(value) 
          ? true
          : hasDefaultValue(value);
      }

      bool hasValue(Json[] value) {
        return hasEntryValue(value) 
          ? true
          : hasDefaultValue(value);
      }

      bool hasValue(Json[string] value) {
        return hasEntryValue(value) 
          ? true
          : hasDefaultValue(value);
      }

      bool hasValue(Json value) {
        return hasEntryValue(value) 
          ? true
          : hasDefaultValue(value);
      }
    // #endregion values
  // #endregion hasValue

  // #region is
    // #region empty
      mixin(IsAction!("Empty", "Entries", "Entry", "string"));

      bool isEmptyEntry(string key) {
        return hasKey(key)
          ? entry(key).isEmpty : false;
      }

      unittest {
        auto config = MemoryConfiguration;

/*         config.setEntry("a", "");
        assert(config.hasKey("a") && !config.hasKey("b"));

        config.setEntry(["b", "c"], "");
        assert(config.hasKey("b") && config.hasKey("c")); */
      }
    // #endregion empty

    // #region boolean
      mixin(IsAction!("Boolean", "Entries", "Entry", "string"));

      bool isBooleanEntry(string key) {
        return hasKey(key)
          ? entry(key).isBoolean : false;
      }

      unittest {
        auto config = MemoryConfiguration;

/*         config.set("a", true);
        assert(config.hasKey("a") && !config.hasKey("b"));

        config.set(["b", "c"], false);
        assert(config.hasKey("b") && config.hasKey("c")); */
      }
    // #endregion boolean

    // #region long
      mixin(IsAction!("Long", "Entries", "Entry", "string"));

      bool isLongEntry(string key) {
        return hasKey(key)
          ? entry(key).isLong : false;
      }

      unittest {
        auto config = MemoryConfiguration;

        /* config.setEntry("a", 1);
        assert(config.hasKey("a") && !config.hasKey("b"));

        config.ssetEntryet(["b", "c"], 2);
        assert(config.hasKey("b") && config.hasKey("c")); */
      }
    // #endregion long

    // #region double
      mixin(IsAction!("Double", "Entries", "Entry", "string"));

      bool isDoubleEntry(string key) {
        return hasKey(key)
          ? entry(key).isDouble : false;
      }

      unittest {
        auto config = MemoryConfiguration;

/*         config.set("a", 1.1);
        assert(config.hasKey("a") && !config.hasKey("b"));

        config.set(["b", "c"], 2.2);
        assert(config.hasKey("b") && config.hasKey("c")); */
      }
    // #endregion double

    // #region string
      mixin(IsAction!("String", "Entries", "Entry", "string"));

      bool isStringEntry(string key) {
        return hasKey(key)
          ? entry(key).isString : false;
      }

      unittest {
        auto config = MemoryConfiguration;

/*         config.set("a", "text");
        assert(config.hasKey("a") && !config.hasKey("b"));

        config.set(["b", "c"], "xtx");
        assert(config.hasKey("b") && config.hasKey("c")); */
      }
    // #endregion string

    // #region array
      mixin(IsAction!("Array", "Entries", "Entry", "string"));
      
      bool isArrayEntry(string key) {
        return hasKey(key)
          ? entry(key).isArray : false;
      }

      unittest {
        auto config = MemoryConfiguration;

/*         Json[] values = [Json(1), Json(2), Json(3)];
        config.set("a", values);
        assert(config.hasKey("a") && !config.hasKey("b"));

        config.set(["b", "c"], values);
        assert(config.hasKey("b") && config.hasKey("c")); */
      }
    // #endregion array

    // #region map
      mixin(IsAction!("Map", "Entries", "Entry", "string"));
      
      bool isMapEntry(string key) {
        return hasKey(key)
          ? entry(key).isMap : false;
      }

      unittest {
        auto config = MemoryConfiguration;

/*         Json[string] values = ["a": Json(1), "b": Json(2), "c": Json(3)];
        config.set("a", true);
        assert(config.hasKey("a") && !config.hasKey("b"));

        config.set(["b", "c"], values);
        assert(config.hasKey("b") && config.hasKey("c")); */
      }
    // #endregion map
  // #endregion is

  // #region set
    // #region defaults
      mixin(SetAction!("IConfiguration", "Defaults", "Default", "string", "bool"));
      mixin(SetAction!("IConfiguration", "Defaults", "Default", "string", "long"));
      mixin(SetAction!("IConfiguration", "Defaults", "Default", "string", "double"));
      mixin(SetAction!("IConfiguration", "Defaults", "Default", "string", "string"));
      mixin(SetAction!("IConfiguration", "Defaults", "Default", "string", "Json[string]"));
      mixin(SetAction!("IConfiguration", "Defaults", "Default", "string", "Json[]"));
      mixin(SetAction!("IConfiguration", "Defaults", "Default", "string", "Json"));
    // #endregion defaults
  
    // #region default
      IConfiguration setDefault(string key, bool value) {
        return setDefault(key, value.toJson);
      }

      IConfiguration setDefault(string key, long value) {
        return setDefault(key, value.toJson);
      }

      IConfiguration setDefault(string key, double value) {
        return setDefault(key, value.toJson);
      }

      IConfiguration setDefault(string key, string value) {
        return setDefault(key, value.toJson);
      }

      IConfiguration setDefault(string key, Json[] value) {
        return setDefault(key, value.toJson);
      }

      IConfiguration setDefault(string key, Json[string] value) {
        return setDefault(key, value.toJson);
      }

      abstract IConfiguration setDefault(string key, Json value);

      unittest {
        auto config = MemoryConfiguration;

/*         config.setDefault("a", true);
        assert(config.hasDefault("a") && config.default_("a") == Json(true) && config.default_("a").getBoolean);

        config.setDefault("b", 10);
        assert(config.hasDefault("b") && config.default_("b") == Json(10) && config.default_("b").getLong == 10);

        config.setDefault("c", 1.1);
        assert(config.hasDefault("c") && config.default_("c") == Json(1.1) && config.default_("c").getDouble == 1.1);

        config.setDefault("e", "text");
        assert(config.hasDefault("e") && config.default_("e") == Json("text") && config.default_("e").getString == "text");

        Json[] list = [Json(1), Json(2), Json(3)];
        config.setDefault("f", list);
        assert(config.hasDefault("f") && config.default_("f") == Json(list) && config.default_("f").getArray == list);

        Json[string] map = ["a": Json(1), "b": Json(2), "c": Json(3)];
        config.setDefault("g", map);
        assert(config.hasDefault("g") && config.default_("g") == Json(map) && config.default_("g").getMap == map); */

        config.setDefault("h", Json(true));
        assert(config.hasDefault("h") && config.default_("h") == Json(true) && config.default_("h").getBoolean);
      }
    // #endregion default

    // #region entries
      mixin(SetAction!("IConfiguration", "Entries", "Entry", "string", "bool"));
      mixin(SetAction!("IConfiguration", "Entries", "Entry", "string", "long"));
      mixin(SetAction!("IConfiguration", "Entries", "Entry", "string", "double"));
      mixin(SetAction!("IConfiguration", "Entries", "Entry", "string", "string"));
      mixin(SetAction!("IConfiguration", "Entries", "Entry", "string", "Json[string]"));
      mixin(SetAction!("IConfiguration", "Entries", "Entry", "string", "Json[]"));
      mixin(SetAction!("IConfiguration", "Entries", "Entry", "string", "Json"));
    // #endregion entries
  
    // #region entry
      void opIndexAssign(bool value, string key) {
        setEntry(key, value);
      }

      void opIndexAssign(long value, string key) {
        setEntry(key, value);
      }

      void opIndexAssign(double value, string key) {
        setEntry(key, value);
      }

      void opIndexAssign(string value, string key) {
        setEntry(key, value);
      }

      void opIndexAssign(Json value, string key) {
        setEntry(key, value);
      }

      void opIndexAssign(Json[] value, string key) {
        setEntry(key, value);
      }

      void opIndexAssign(Json[string] value, string key) {
        setEntry(key, value);
      }

      IConfiguration setEntry(string key, bool value) {
        return setEntry(key, value.toJson);
      }

      IConfiguration setEntry(string key, long value) {
        return setEntry(key, value.toJson);
      }

      IConfiguration setEntry(string key, double value) {
        return setEntry(key, value.toJson);
      }

      IConfiguration setEntry(string key, string value) {
        return setEntry(key, value.toJson);
      }

      IConfiguration setEntry(string key, Json[] value) {
        return setEntry(key, value.toJson);
      }

      IConfiguration setEntry(string key, Json[string] value) {
        return setEntry(key, value.toJson);
      }

      abstract IConfiguration setEntry(string key, Json value);
    // #endregion entry

    unittest{
      auto config = MemoryConfiguration;

      Json j1 = Json(true);
      Json j2 = Json(1);
      Json j3 = Json("a");
      config.setDefaults(["a", "b"], j1);
      assert(config.hasDefault("a") && config.hasDefault("b"));

      Json[string] map1 = [
        "e": j1,
        "f": j2,
        "g": j3
      ];
      config.setDefaults(map1);
      assert(config.hasDefault("e") && config.hasDefault("f") && config.hasDefault("g"));
      assert(config.hasDefault("a") && config.hasDefault("b") && config.hasDefault("e") && config.hasDefault("f") && config.hasDefault("g"));
      assert(!config.hasDefault("x"));

      Json[] ja1 = [Json(true)];
      Json[] ja2 = [Json(1)];
      Json[] ja3 = [Json("a")];
      config.setDefaults(["aa", "bb"], ja1);
      assert(config.hasDefault("aa") && config.hasDefault("bb"));

      Json[][string] map2 = [
        "ee": ja1,
        "ff": ja2,
        "gg": ja3
      ];
      config.setDefaults(map2);
      assert(config.hasDefault("ee") && config.hasDefault("ff") && config.hasDefault("gg"));
      assert(config.hasDefault("aa") && config.hasDefault("bb") && config.hasDefault("ee") && config.hasDefault("ff") && config.hasDefault("gg"));
      assert(!config.hasDefault("x"));

      Json[string] jm1 = ["x": Json(true)];
      Json[string] jm2 = ["x": Json(1)];
      Json[string] jm3 = ["x": Json("a")];
      config.setDefaults(["aaa", "bbb"], ja1);
      assert(config.hasDefault("aaa") && config.hasDefault("bbb"));

      Json[string][string] map3 = [
        "eee": jm1,
        "fff": jm2,
        "ggg": jm3
      ];
      config.setDefaults(map3);
      assert(config.hasDefault("eee") && config.hasDefault("fff") && config.hasDefault("ggg"));
      assert(config.hasDefault("aaa") && config.hasDefault("bbb") && config.hasDefault("eee") && config.hasDefault("fff") && config.hasDefault("ggg"));
      assert(!config.hasDefault("x"));

      config.setDefaults(["text_a", "text_b"], "text");
      assert(config.hasDefault("text_a") && config.hasDefault("text_b"));

      string[string] map4 = [
        "text_e": "text1",
        "text_f": "text2",
        "text_g": "text3"
      ];
      config.setDefaults(map4);
      assert(config.hasDefault("text_e") && config.hasDefault("text_f") && config.hasDefault("text_g"));
      assert(config.hasDefault("text_a") && config.hasDefault("text_b") && config.hasDefault("text_e") && config.hasDefault("text_f") && config.hasDefault("text_g"));
      assert(!config.hasDefault("x"));

      config.setDefaults(["double_a", "double_b"], 4.4);
      assert(config.hasDefault("double_a") && config.hasDefault("double_b"));

      double[string] map5 = [
        "double_e": 1.1,
        "double_f": 2.2,
        "double_g": 3.3
      ];
      config.setDefaults(map5);
      assert(config.hasDefault("double_e") && config.hasDefault("double_f") && config.hasDefault("double_g"));
      assert(config.hasDefault("double_a") && config.hasDefault("double_b") && config.hasDefault("double_e") && config.hasDefault("double_f") && config.hasDefault("double_g"));
      assert(!config.hasDefault("x"));

      config.setDefaults(["long_a", "long_b"], 4);
      assert(config.hasDefault("long_a") && config.hasDefault("long_b"));

      long[string] map6 = [
        "long_e": 1,
        "long_f": 2,
        "long_g": 3
      ];
      config.setDefaults(map6);
      assert(config.hasDefault("long_e") && config.hasDefault("long_f") && config.hasDefault("long_g"));
      assert(config.hasDefault("long_a") && config.hasDefault("long_b") && config.hasDefault("long_e") && config.hasDefault("long_f") && config.hasDefault("long_g"));
      assert(!config.hasDefault("x"));

      config.setDefaults(["bool_a", "bool_b"], true);
      assert(config.hasDefault("bool_a") && config.hasDefault("bool_b"));

      bool[string] map7 = [
        "bool_e": true,
        "bool_f": true,
        "bool_g": true
      ];
      config.setDefaults(map7);
      assert(config.hasDefault("bool_e") && config.hasDefault("bool_f") && config.hasDefault("bool_g"));
      assert(config.hasDefault("bool_a") && config.hasDefault("bool_b") && config.hasDefault("bool_e") && config.hasDefault("bool_f") && config.hasDefault("bool_g"));
      assert(!config.hasDefault("x"));
    }
  // #endregion set

  // #region update
    // #region defaults
      mixin(UpdateAction!("IConfiguration", "Defaults", "Default", "string", "bool"));
      mixin(UpdateAction!("IConfiguration", "Defaults", "Default", "string", "long"));
      mixin(UpdateAction!("IConfiguration", "Defaults", "Default", "string", "double"));
      mixin(UpdateAction!("IConfiguration", "Defaults", "Default", "string", "string"));
      mixin(UpdateAction!("IConfiguration", "Defaults", "Default", "string", "Json[string]"));
      mixin(UpdateAction!("IConfiguration", "Defaults", "Default", "string", "Json[]"));
      mixin(UpdateAction!("IConfiguration", "Defaults", "Default", "string", "Json"));
    // #endregion defaults

    // #region default
      IConfiguration updateDefault(string key, bool value) {
        return updateDefault(key, value.toJson);
      }

      IConfiguration updateDefault(string key, long value) {
        return updateDefault(key, value.toJson);
      }

      IConfiguration updateDefault(string key, double value) {
        return updateDefault(key, value.toJson);
      }

      IConfiguration updateDefault(string key, string value) {
        return updateDefault(key, value.toJson);
      }
      
      IConfiguration updateDefault(string key, Json[] value) {
        return updateDefault(key, value.toJson);
      }

      IConfiguration updateDefault(string key, Json[string] value) {
        return updateDefault(key, value.toJson);
      }

      IConfiguration updateDefault(string key, Json value) {
        if (hasDefault(key)) {
          setDefault(key, value);
        }
        return this;
      }

      unittest {
        // TODO
      }
    // #endregion default

    // #region entries
      mixin(UpdateAction!("IConfiguration", "Entries", "Entry", "string", "bool"));
      mixin(UpdateAction!("IConfiguration", "Entries", "Entry", "string", "long"));
      mixin(UpdateAction!("IConfiguration", "Entries", "Entry", "string", "double"));
      mixin(UpdateAction!("IConfiguration", "Entries", "Entry", "string", "string"));
      mixin(UpdateAction!("IConfiguration", "Entries", "Entry", "string", "Json[string]"));
      mixin(UpdateAction!("IConfiguration", "Entries", "Entry", "string", "Json[]"));
      mixin(UpdateAction!("IConfiguration", "Entries", "Entry", "string", "Json"));

      unittest {
        // TODO
      }
    // #endregion entries

    // #region entry
      IConfiguration updateEntry(string key, bool value) {
        return updateEntry(key, value.toJson);
      }
      
      IConfiguration updateEntry(string key, long value) {
        return updateEntry(key, value.toJson);
      }
      
      IConfiguration updateEntry(string key, double value) {
        return updateEntry(key, value.toJson);
      }
      
      IConfiguration updateEntry(string key, string value) {
        return updateEntry(key, value.toJson);
      }

      IConfiguration updateEntry(string key, Json[] value) {
        return updateEntry(key, value.toJson);
      }

      IConfiguration updateEntry(string key, Json[string] value) {
        return updateEntry(key, value.toJson);
      }

      IConfiguration updateEntry(string key, Json value) {
        if (hasEntry(key)) {
          setEntry(key, value);
        }
        return this;
      }

      unittest {
        // TODO
      }
    // #endregion entry
  // #endregion update

  // #region merge
    // #region defaults
      mixin(MergeAction!("IConfiguration", "Defaults", "Default", "string", "bool"));
      mixin(MergeAction!("IConfiguration", "Defaults", "Default", "string", "long"));
      mixin(MergeAction!("IConfiguration", "Defaults", "Default", "string", "double"));
      mixin(MergeAction!("IConfiguration", "Defaults", "Default", "string", "string"));
      mixin(MergeAction!("IConfiguration", "Defaults", "Default", "string", "Json[string]"));
      mixin(MergeAction!("IConfiguration", "Defaults", "Default", "string", "Json[]"));
      mixin(MergeAction!("IConfiguration", "Defaults", "Default", "string", "Json"));
    // #endregion defaults

    // #region default
      IConfiguration mergeDefault(string key, bool value) {
        return mergeDefault(key, value.toJson);
      }

      IConfiguration mergeDefault(string key, long value) {
        return mergeDefault(key, value.toJson);
      }

      IConfiguration mergeDefault(string key, double value) {
        return mergeDefault(key, value.toJson);
      }

      IConfiguration mergeDefault(string key, string value) {
        return mergeDefault(key, value.toJson);
      }

      IConfiguration mergeDefault(string key, Json[] value) {
        return mergeDefault(key, value.toJson);
      }

      IConfiguration mergeDefault(string key, Json[string] value) {
        return mergeDefault(key, value.toJson);
      }

      IConfiguration mergeDefault(string key, Json value) {
        if (!hasDefault(key)) {
          setDefault(key, value);
        }
        return this;
      }
    // #endregion default

    // #region entries
      mixin(MergeAction!("IConfiguration", "Entries", "Entry", "string", "bool"));
      mixin(MergeAction!("IConfiguration", "Entries", "Entry", "string", "long"));
      mixin(MergeAction!("IConfiguration", "Entries", "Entry", "string", "double"));
      mixin(MergeAction!("IConfiguration", "Entries", "Entry", "string", "string"));
      mixin(MergeAction!("IConfiguration", "Entries", "Entry", "string", "Json[string]"));
      mixin(MergeAction!("IConfiguration", "Entries", "Entry", "string", "Json[]"));
      mixin(MergeAction!("IConfiguration", "Entries", "Entry", "string", "Json"));
    // #endregion entries

    // #region entry
      IConfiguration mergeEntry(string key, bool value) {
        return mergeEntry(key, value.toJson);
      }

      IConfiguration mergeEntry(string key, long value) {
        return mergeEntry(key, value.toJson);
      }

      IConfiguration mergeEntry(string key, double value) {
        return mergeEntry(key, value.toJson);
      }

      IConfiguration mergeEntry(string key, string value) {
        return mergeEntry(key, value.toJson);
      }

      IConfiguration mergeEntry(string key, Json[] value) {
        return mergeEntry(key, value.toJson);
      }

      IConfiguration mergeEntry(string key, Json[string] value) {
        return mergeEntry(key, value.toJson);
      }
      
      IConfiguration mergeEntry(string key, Json value) {
        if (!hasEntry(key)) {
          setEntry(key, value);
        }
        return this;
      }
    // #endregion entry  
  // #endregion merge
 
  // #region keys
  abstract string[] keys();
  // #endregion keys

  // #region values
  abstract Json[] defaultValues(string[] keys = null);
  abstract Json[] entryValues(string[] keys = null);
  // #endregion values


  // #region read
    mixin(ReadAction!("Json", "entries", "entry", "string"));

    bool entryBoolean(string key) {
      return hasKey(key) ? entry(key).getBoolean : false;
    }

    long entryLong(string key) {
      return hasKey(key) ? entry(key).getLong : 0;
    }

    double entryDouble(string key) {
      return hasKey(key) ? entry(key).getDouble : 0.0;
    }

    string entryString(string key, string nullValue = null) {
      return hasKey(key) ? entry(key).getString : null;
    }

    string[] entryStringArray(string key) {
      return entryArray(key)
        .map!(item => item.getString).array;
    }

    Json[] entryArray(string key) {
      return hasKey(key) && isArray(key)
        ? entry(key).getArray : null;
    }

    Json[string] entryMap(string key) {
      return hasKey(key) && isMap(key)
        ? entry(key).getMap : null;
    }

    string[string] entryStringMap(string key) {
      string[string] result;
      entryMap(key).each!((key, value) => result[key] = value.get!string);
      return result;
    }

    abstract Json entry(string key);

    unittest {
      auto config = MemoryConfiguration;
      // TODO
    }
  // #endregion get

  // #region shift
    // #region defaults
      mixin(GetAction!("Json", "shift", "Defaults", "Default", "string")); 

      Json shiftDefault(string key) {
        if (!hasKey(key)) {
          return Json(null);
        }

        auto value = entry(key);
        removeDefault(key);
        return value;
      }

      unittest {
        auto config = MemoryConfiguration;
        // TODO
      }
    // #region defaults

    // #region entries
      mixin(GetAction!("Json", "shift", "Entries", "Entry", "string")); 

      Json shiftEntry(string key) {
        if (!hasKey(key)) {
          return Json(null);
        }

        auto value = entry(key);
        removeEntry(key);
        return value;
      }

      unittest {
        auto config = MemoryConfiguration;
        // TODO
      }     
    // #region entries
  // #endregion shift

  // #region remove
    // #region defaults
      mixin(RemoveAction!("IConfiguration", "Defaults", "Default", "string"));
    
      IConfiguration clearDefaults() {
        removeDefaults(keys);
        return this;
      }

      abstract IConfiguration removeDefault(string key);

      unittest {
        auto config = MemoryConfiguration;
        // TODO
      }
    // #endregion defaults

    // #region entries
      mixin(RemoveAction!("IConfiguration", "Entries", "Entry", "string"));
    
      IConfiguration clearEntries() {
        removeEntries(keys);
        return this;
      }

      abstract IConfiguration removeEntry(string key);

      unittest {
        auto config = MemoryConfiguration;
        // TODO
      }
    // #endregion entries
  // #endregion remove

  // #region clone
    abstract IConfiguration clone(); 

    unittest {
      auto config = MemoryConfiguration;
      // TODO
    }
  // #endregion clone
}
