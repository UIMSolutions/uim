/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.configurations.configuration;

mixin(Version!"test_uim_oop");

import uim.oop;
@safe:

private alias KeyValue = Tuple!(string, "key", Json, "value");

// Configuration for handling config data = key: string / value: Json
class DConfiguration : UIMObject, IConfiguration {
  mixin(ConfigurationThis!("Configuration"));

  override bool initialize(Json[string] initData = null) {
    // writeln("DConfiguration::initialize(Json[string] initData = null) - ", this.classinfo);
    return true;
  }

  // #region defaultData
  abstract Json[string] defaultData();

  abstract IConfiguration defaultData(Json[string] newData);
  @property auto byKeyValue()
  @trusted {
    return data.byKeyValue.map!(kv => KeyValue(kv.key, kv.value)).array;
  }

  bool hasAnyDefaults(string[] keys) {
    return keys
      .filter!(key => key.length > 0)
      .any!(key => hasDefault(key));
  }

  bool hasAllDefaults(string[] keys) {
    return keys
      .filter!(key => key.length > 0)
      .all!(key => hasDefault(key));
  }

  abstract bool hasDefault(string key);
  abstract Json getDefault(string key);

  // #region updateDefault
  IConfiguration updateDefault(string[] keys, bool newValue) {
    keys.each!(key => setDefault(key, newValue));
    return this;
  }

  IConfiguration updateDefault(string[] keys, long newValue) {
    keys.each!(key => setDefault(key, newValue));
    return this;
  }

  IConfiguration updateDefault(string[] keys, double newValue) {
    keys.each!(key => setDefault(key, newValue));
    return this;
  }

  IConfiguration updateDefault(string[] keys, string newValue) {
    keys.each!(key => setDefault(key, newValue));
    return this;
  }

  IConfiguration updateDefault(string[] keys, Json newValue) {
    keys.each!(key => setDefault(key, newValue));
    return this;
  }

  IConfiguration updateDefault(string[] keys, Json[] newValue) {
    keys.each!(key => setDefault(key, newValue));
    return this;
  }

  IConfiguration updateDefault(string[] keys, Json[string] newValue) {
    keys.each!(key => setDefault(key, newValue));
    return this;
  }

  IConfiguration updateDefault(string key, bool newValue) {
    return hasKey(key)
      ? set(key, newValue) : this;
  }

  IConfiguration updateDefault(string key, long newValue) {
    return hasKey(key)
      ? set(key, newValue) : this;
  }

  IConfiguration updateDefault(string key, double newValue) {
    return hasKey(key)
      ? set(key, newValue) : this;
  }

  IConfiguration updateDefault(string key, string newValue) {
    return hasKey(key)
      ? set(key, newValue) : this;
  }

  IConfiguration updateDefault(string key, Json newValue) {
    return hasKey(key)
      ? set(key, newValue) : this;
  }

  IConfiguration updateDefault(string key, Json[] newValue) {
    return hasKey(key)
      ? set(key, newValue) : this;
  }

  IConfiguration updateDefault(string key, Json[string] newValue) {
    return hasKey(key)
      ? set(key, newValue) : this;
  }
  // #endregion updateDefault

  // #region setDefaults
    mixin(SetAction!("IConfiguration", "Defaults", "Default", "string", "bool", "values"));
    mixin(SetAction!("IConfiguration", "Defaults", "Default", "string", "long", "values"));
    mixin(SetAction!("IConfiguration", "Defaults", "Default", "string", "double", "values"));
    mixin(SetAction!("IConfiguration", "Defaults", "Default", "string", "string", "values"));
    mixin(SetAction!("IConfiguration", "Defaults", "Default", "string", "Json[string]", "values"));
    mixin(SetAction!("IConfiguration", "Defaults", "Default", "string", "Json[]", "values"));
    mixin(SetAction!("IConfiguration", "Defaults", "Default", "string", "Json", "values"));
    
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
  // #endregion setDefaults

  // #region setDefault
    IConfiguration setDefault(string key, bool value) {
      return setDefault(key, Json(value));
    }

    IConfiguration setDefault(string key, long value) {
      return setDefault(key, Json(value));
    }

    IConfiguration setDefault(string key, double value) {
      return setDefault(key, Json(value));
    }

    IConfiguration setDefault(string key, string value) {
      return setDefault(key, Json(value));
    }

    IConfiguration setDefault(string key, Json[] value) {
      return setDefault(key, value.toJson);
    }

    IConfiguration setDefault(string key, Json[string] value) {
      return setDefault(key, value.toJson);
    }

    abstract IConfiguration setDefault(string key, Json value);
  // #endregion setDefaults

  // #region mergeDefault
  IConfiguration mergeDefaults(T)(T[string] items) {
    items.each!((key, value) => mergeDefault(key, value));
    return this;
  }

  IConfiguration mergeDefaults(T)(string[] keys, T value) {
    keys.each!((key, value) => mergeDefault(key, value));
    return this;
  }

  IConfiguration mergeDefaults(T)(string key, T value) {
    mergeDefault(key, Json(value));
    return this;
  }

  IConfiguration mergeDefault(string key, Json value) {
    if (!hasKey(key)) {
      setDefault(key, value);
    }
    return this;
  }
  // #endregion mergeDefault

  // #region data
  abstract Json[string] data();

  abstract void data(Json[string] newData);

  void opAssign(Json[string] newData) {
    data(newData);
  }
  // #endregion data

  // #region keys
  mixin(HasAction!("Keys", "Key", "string", "keys"));

  abstract bool hasKey(string key);

  abstract string[] keys();
  // #endregion keys

  // #region values
  mixin(HasAction!("Values", "Value", "Json", "values"));

  abstract bool hasValue(Json value);

  abstract Json[] values(string[] includedKeys = null);
  // #endregion values

  // #region is
    // #region empty
      mixin(IsAction!("Empty", "Entries", "Entry", "string", "keys"));

      bool isEmptyEntry(string key) {
        return hasKey(key)
          ? get(key).isEmpty : false;
      }

      unittest {
        auto config = MemoryConfiguration;

        config.set("a", "");
        assert(config.hasKey("a") && !config.hasKey("b"));

        config.set(["b", "c"], "");
        assert(config.hasKey("b") && config.hasKey("c"));
      }
    // #endregion empty

    // #region boolean
      mixin(IsAction!("Boolean", "Entries", "Entry", "string", "keys"));

      bool isBooleanEntry(string key) {
        return hasKey(key)
          ? get(key).isBoolean : false;
      }

      unittest {
        auto config = MemoryConfiguration;

        config.set("a", true);
        assert(config.hasKey("a") && !config.hasKey("b"));

        config.set(["b", "c"], false);
        assert(config.hasKey("b") && config.hasKey("c"));
      }
    // #endregion boolean

    // #region long
      mixin(IsAction!("Long", "Entries", "Entry", "string", "keys"));

      bool isLongEntry(string key) {
        return hasKey(key)
          ? get(key).isLong : false;
      }

      unittest {
        auto config = MemoryConfiguration;

        config.set("a", 1);
        assert(config.hasKey("a") && !config.hasKey("b"));

        config.set(["b", "c"], 2);
        assert(config.hasKey("b") && config.hasKey("c"));
      }
    // #endregion long

    // #region double
      mixin(IsAction!("Double", "Entries", "Entry", "string", "keys"));

      bool isDoubleEntry(string key) {
        return hasKey(key)
          ? get(key).isDouble : false;
      }

      unittest {
        auto config = MemoryConfiguration;

        config.set("a", 1.1);
        assert(config.hasKey("a") && !config.hasKey("b"));

        config.set(["b", "c"], 2.2);
        assert(config.hasKey("b") && config.hasKey("c"));
      }
    // #endregion double

    // #region string
      mixin(IsAction!("String", "Entries", "Entry", "string", "keys"));

      bool isStringEntry(string key) {
        return hasKey(key)
          ? get(key).isString : false;
      }

      unittest {
        auto config = MemoryConfiguration;

        config.set("a", "text");
        assert(config.hasKey("a") && !config.hasKey("b"));

        config.set(["b", "c"], "xtx");
        assert(config.hasKey("b") && config.hasKey("c"));
      }
    // #endregion string

    // #region array
      mixin(IsAction!("Array", "Entries", "Entry", "string", "keys"));
      
      bool isArrayEntry(string key) {
        return hasKey(key)
          ? get(key).isArray : false;
      }

      unittest {
        auto config = MemoryConfiguration;

        Json[] values = [Json(1), Json(2), Json(3)];
        config.set("a", values);
        assert(config.hasKey("a") && !config.hasKey("b"));

        config.set(["b", "c"], values);
        assert(config.hasKey("b") && config.hasKey("c"));
      }
    // #endregion array

    // #region map
      mixin(IsAction!("Map", "Entries", "Entry", "string", "keys"));
      
      bool isMapEntry(string key) {
        return hasKey(key)
          ? get(key).isMap : false;
      }

      unittest {
        auto config = MemoryConfiguration;

        Json[string] values = ["a": Json(1), "b": Json(2), "c": Json(3)];
        config.set("a", true);
        assert(config.hasKey("a") && !config.hasKey("b"));

        config.set(["b", "c"], values);
        assert(config.hasKey("b") && config.hasKey("c"));
      }
    // #endregion map
  // #endregion is

  // #region get
  Json opIndex(string key) {
    return get(key);
  }

  Json[string] get(string[] keys, bool compressMode = false) {
    Json[string] results;

    keys
      .filter!(key => !compressMode || !key.isNull)
      .each!(key => results[key] = get(key));

    return results;
  }

  abstract Json get(string key, Json nullValue = Json(null));

  bool getBoolean(string key, bool nullValue = false) {
    return hasKey(key) ? get(key).getBoolean : nullValue;
  }

  long getLong(string key, long nullValue = 0) {
    return hasKey(key) ? get(key).getLong : nullValue;
  }

  double getDouble(string key, double nullValue = 0.0) {
    return hasKey(key) ? get(key).getDouble : nullValue;
  }

  string getString(string key, string nullValue = null) {
    return hasKey(key) ? get(key).getString : nullValue;
  }

  string[] getStringArray(string key, string[] nullValue = null) {
    return getArray(key)
      .map!(item => item.getString).array;
  }

  Json[] getArray(string key) {
    return hasKey(key) && isArray(key)
      ? get(key).getArray : null;
  }

  Json[string] getMap(string key) {
    return hasKey(key) && isMap(key)
      ? get(key).getMap : null;
  }

  string[string] getStringMap(string key) {
    string[string] result;
    getMap(key).each!((key, value) => result[key] = value.get!string);
    return result;
  }

  Json getJson(string key) {
    return get(key);
  }
  // #endregion get

  //#region set
  IConfiguration set(string[string] data, string[] keys = null) {
    Json[string] map;
    keys
      .filter!(key => key in data)
      .each!(key => map[key] = Json(data[key]));

    return set(map);
  }

  IConfiguration set(Json[string] newData, string[] keys = null) {
    keys.isNull
      ? keys.each!(key => set(key, newData[key])) : keys.filter!(key => key in newData)
      .each!(key => set(key, newData[key]));

    return this;
  }

  mixin(DataIndexAssign!());
  mixin(SetDataMulti!("IConfiguration"));
  mixin(SetDataSingle!("IConfiguration"));

  abstract IConfiguration set(string key, Json value);
  abstract IConfiguration set(string key, Json[] value);
  abstract IConfiguration set(string key, Json[string] value);
  //#endregion set

  // #region update
  IConfiguration update(Json[string] newItems, string[] validKeys = null) {
    validKeys.isNull
      ? newItems.each!((key, value) => updateEntry(key, value)) : newItems.byKeyValue
      .filter!(item => validKeys.has(item.key))
      .each!(item => update(item.key, item.value));

    return this;
  }

  mixin(UpdateAction!("IConfiguration", "Entries", "Entry", "string", "bool", "values"));
  mixin(UpdateAction!("IConfiguration", "Entries", "Entry", "string", "long", "values"));
  mixin(UpdateAction!("IConfiguration", "Entries", "Entry", "string", "double", "values"));
  mixin(UpdateAction!("IConfiguration", "Entries", "Entry", "string", "string", "values"));
  mixin(UpdateAction!("IConfiguration", "Entries", "Entry", "string", "Json", "values"));

  IConfiguration update(string[] keys, Json[] value) {
    keys.each!(key => updateEntry(key, value));
    return this;
  }

  IConfiguration update(string[] keys, Json[string] value) {
    keys.each!(key => updateEntry(key, value));
    return this;
  }

  IConfiguration updateEntry(string key, bool newValue) {
    return updateEntry(key, Json(newValue));
  }

  IConfiguration updateEntry(string key, long newValue) {
    return updateEntry(key, Json(newValue));
  }

  IConfiguration updateEntry(string key, double newValue) {
    return updateEntry(key, Json(newValue));
  }

  IConfiguration updateEntry(string key, string newValue) {
    return updateEntry(key, Json(newValue));
  }

  IConfiguration updateEntry(string key, Json newValue) {
    return hasKey(key)
      ? set(key, newValue) : this;
  }

  IConfiguration updateEntry(string key, Json[] newValue) {
    return hasKey(key)
      ? set(key, newValue) : this;
  }

  IConfiguration updateEntry(string key, Json[string] newValue) {
    return hasKey(key)
      ? set(key, newValue) : this;
  }
  // #region update

  // #region merge
  IConfiguration merge(Json[string] newItems, string[] validKeys = null) {
    validKeys.isNull
      ? newItems.byKeyValue.each!(item => merge(item.key, item.value)) : newItems.byKeyValue
      .filter!(item => validKeys.has(item.key))
      .each!(item => merge(item.key, item.value));

    return this;
  }

  IConfiguration merge(string[] keys, bool newValue) {
    keys.each!(key => merge(key, newValue));
    return this;
  }

  IConfiguration merge(string[] keys, long newValue) {
    keys.each!(key => merge(key, newValue));
    return this;
  }

  IConfiguration merge(string[] keys, double newValue) {
    keys.each!(key => merge(key, newValue));
    return this;
  }

  IConfiguration merge(string[] keys, string newValue) {
    keys.each!(key => merge(key, newValue));
    return this;
  }

  IConfiguration merge(string[] keys, Json newValue) {
    keys.each!(key => merge(key, newValue));
    return this;
  }

  IConfiguration merge(string[] keys, Json[] newValue) {
    keys.each!(key => merge(key, newValue));
    return this;
  }

  IConfiguration merge(string[] keys, Json[string] newValue) {
    keys.each!(key => merge(key, newValue));
    return this;
  }

  IConfiguration merge(string key, bool newValue) {
    return merge(key, Json(newValue));
  }

  IConfiguration merge(string key, long newValue) {
    return merge(key, Json(newValue));
  }

  IConfiguration merge(string key, double newValue) {
    return merge(key, Json(newValue));
  }

  IConfiguration merge(string key, string newValue) {
    return merge(key, Json(newValue));
  }

  IConfiguration merge(string key, Json newValue) {
    return !hasKey(key)
      ? set(key, newValue) : this;
  }

  IConfiguration merge(string key, Json[] newValue) {
    return !hasKey(key)
      ? set(key, newValue) : this;
  }

  IConfiguration merge(string key, Json[string] newValue) {
    return !hasKey(key)
      ? set(key, newValue) : this;
  }
  // #endregion merge

  // #region remove - clear
  IConfiguration clear() {
    removeKey(keys);
    return this;
  }

  IConfiguration removeKey(Json json) {
    if (json.isObject) {
      json.byKeyValue.each!(kv => removeKey(kv.key));
    } else if (json.isArray) {
      foreach (value; json.get!(Json[])) {
        removeKey(value.getString);
      }
    } else if (json.isString) {
      removeKey(json.getString);
    }
    return this;
  }

  IConfiguration removeKey(Json[string] items) {
    removeKey(items.keys);
    return this;
  }

  IConfiguration removeKey(string[] keys...) {
    removeKey(keys.dup);
    return this;
  }

  abstract IConfiguration removeKeys(string[] keys);
  // #region remove - clear

  IConfiguration clone() {
    return null;
  }

  Json shift(string key) {
    if (!hasKey(key)) {
      return Json(null);
    }

    auto value = get(key);
    removeKey(key);
    return value;
  }

}

/* unittest {
    auto config = new DConfiguration();
    assert(config !is null);
    /*     assert(config is IConfiguration);
    assert(config is DConfiguration); * /
    assert(config.initialize());
    assert(config.defaultData().length == 0);
    assert(config.data().length == 0);
    assert(config.keys().length == 0);
    assert(config.values().length == 0);
    assert(config.hasKey("test") == false);
    assert(config.hasValue(Json("test")) == false);
    assert(config.get("test") == Json(null));
    assert(config.get("test", Json("test")) == Json("test"));
    assert(config.get("test", Json(1)) == Json(1));
    assert(config.get("test", Json(1.0)) == Json(1.0));
    assert(config.get("test", Json(true)) == Json(true));
    assert(config.get("test", Json(false)) == Json(false));
    assert(config.get("test", Json([1, 2, 3])) == Json([1, 2, 3]));
    assert(config.get("test", Json(["a", "b", "c"])) == Json(["a", "b", "c"]));
    assert(config.get("test", Json(["a": 1, "b": 2, "c": 3])) == Json([
            "a": 1,
            "b": 2,
            "c": 3
        ]));
    assert(config.get("test", Json(["a": "a", "b": "b", "c": "c"])) == Json([
            "a": "a",
            "b": "b",
            "c": "c"
        ]));
    assert(config.get("test", Json(["a": true, "b": false, "c": true])) == Json([
            "a": true,
            "b": false,
            "c": true
        ]));
    assert(config.get("test", Json(["a": 1, "b": 2, "c": 3])) == Json([
            "a": 1,
            "b": 2,
            "c": 3
        ]));
    assert(config.get("test", Json(["a": 1.0, "b": 2.0, "c": 3.0])) == Json([
            "a": 1.0,
            "b": 2.0,
            "c": 3.0
        ]));
    // assert(config.get("test", Json(["a": "a", "b": "b
}
 */
