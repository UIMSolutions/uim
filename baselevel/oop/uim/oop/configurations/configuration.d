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
class DConfiguration : IConfiguration {
  this() {
    this.name(this.classname);
    this.entries(new Json[string]);
  }

  this(Json[string] initData) {
    this.entries(initData);
    this.name(this.classname);
  }

  this(string newName, Json[string] initData = null) {
    this.entries(initData);
    this.name(newName);
  }

  mixin(TProperty!("string", "name"));

  // #region entries
    abstract Json[string] entries();
    abstract IConfiguration entries(Json[string] newEntries);
 // #endregion entries

  // #region keys
  abstract string[] entryKeys();
  // #endregion keys

  // #region values
  abstract Json[] entryValues();
  // #endregion values

  // #region has
    mixin(HasMethods!("Entries", "Entry", "string"));

    mixin(HasMethods!("EntryValues", "EntryValue", "bool"));
    mixin(HasMethods!("EntryValues", "EntryValue", "long"));
    mixin(HasMethods!("EntryValues", "EntryValue", "double"));
    mixin(HasMethods!("EntryValues", "EntryValue", "string"));
    mixin(HasMethods!("EntryValues", "EntryValue", "Json[]"));
    mixin(HasMethods!("EntryValues", "EntryValue", "Json[string]"));
    mixin(HasMethods!("EntryValues", "EntryValue", "Json"));

    abstract bool hasEntry(string key);
      
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
  // #endregion has

  // #region is
    mixin(IsMethods!("EmptyEntries", "EmptyEntry", "string"));
    mixin(IsMethods!("BooleanEntries", "BooleanEntry", "string"));
    mixin(IsMethods!("LongEntries", "LongEntry", "string")); 
    mixin(IsMethods!("DoubleEntries", "DoubleEntry", "string"));
    mixin(IsMethods!("StringEntries", "StringEntry", "string"));
    mixin(IsMethods!("ArrayEntries", "ArrayEntry", "string"));
    mixin(IsMethods!("MapEntries", "MapEntry", "string"));

    bool isEmptyEntry(string key) {
      return hasEntry(key)
        ? getEntry(key).isEmpty : false;
    }

    bool isBooleanEntry(string key) {
      return hasEntry(key)
        ? getEntry(key).isBoolean : false;
    }

    bool isLongEntry(string key) {
      return hasEntry(key)
        ? getEntry(key).isLong : false;
    }

    bool isDoubleEntry(string key) {
      return hasEntry(key)
        ? getEntry(key).isDouble : false;
    }
     
    bool isStringEntry(string key) {
      return hasEntry(key)
        ? getEntry(key).isString : false;
    }
      
    bool isArrayEntry(string key) {
      return hasEntry(key)
        ? getEntry(key).isArray : false;
    }

    bool isMapEntry(string key) {
      return hasEntry(key)
        ? getEntry(key).isMap : false;
    }

      unittest {
        auto config = MemoryConfiguration;

/*         Json[string] values = ["a": Json(1), "b": Json(2), "c": Json(3)];
        config.set("a", true);
        assert(config.hasEntry("a") && !config.hasEntry("b"));

        config.set(["b", "c"], values);
        assert(config.hasEntry("b") && config.hasEntry("c")); */
      }
  // #endregion is

  // #region get
    mixin(GetMethods!("bool", "BooleanEntries", "BooleanEntry", "string"));
    mixin(GetMethods!("long", "LongEntries", "LongEntry", "string"));
    mixin(GetMethods!("double", "DoubleEntries", "DoubleEntry", "string"));
    mixin(GetMethods!("string", "StringEntries", "StringEntry", "string"));
    mixin(GetMethods!("Json[]", "ArrayEntries", "ArrayEntry", "string"));
    mixin(GetMethods!("Json[string]", "MapEntries", "MapEntry", "string"));
    mixin(GetMethods!("Json", "Entries", "Entry", "string"));

    bool getBooleanEntry(string key) {
      return hasEntry(key) ? getEntry(key).getBoolean : false;
    }

    long getLongEntry(string key) {
      return hasEntry(key) ? getEntry(key).getLong : 0;
    }

    double getDoubleEntry(string key) {
      return hasEntry(key) ? getEntry(key).getDouble : 0.0;
    }

    string getStringEntry(string key) {
      return hasEntry(key) ? getEntry(key).getString : null;
    }

    Json[] getArrayEntry(string key) {
      return hasEntry(key) && getEntry(key).isArray
        ? getEntry(key).getArray : null;
    }

    Json[string] getMapEntry(string key) {
      return hasEntry(key) && getEntry(key).isMap
        ? getEntry(key).getMap : null;
    }

    abstract Json getEntry(string key);

    unittest {
      auto config = MemoryConfiguration;
      // TODO
    }
  // #endregion get

  // #region shift
    mixin(ShiftMethods!("Json", "Entries", "Entry", "string")); 

    Json shiftEntry(string key) {
      if (!hasEntry(key)) {
        return Json(null);
      }

      auto value = getEntry(key);
      removeEntry(key);
      return value;
    }

    unittest {
      auto config = MemoryConfiguration;
      // TODO
    }     
  // #endregion shift

  // #region set
    mixin(SetMethods!("IConfiguration", "Entries", "Entry", "string", "bool"));
    mixin(SetMethods!("IConfiguration", "Entries", "Entry", "string", "long"));
    mixin(SetMethods!("IConfiguration", "Entries", "Entry", "string", "double"));
    mixin(SetMethods!("IConfiguration", "Entries", "Entry", "string", "string"));
    mixin(SetMethods!("IConfiguration", "Entries", "Entry", "string", "Json[string]"));
    mixin(SetMethods!("IConfiguration", "Entries", "Entry", "string", "Json[]"));
    mixin(SetMethods!("IConfiguration", "Entries", "Entry", "string", "Json"));

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

    unittest{
      auto config = MemoryConfiguration;

      // TODO 
    }
  // #endregion set

  // #region update
    mixin(UpdateMethods!("IConfiguration", "Entries", "Entry", "string", "bool"));
    mixin(UpdateMethods!("IConfiguration", "Entries", "Entry", "string", "long"));
    mixin(UpdateMethods!("IConfiguration", "Entries", "Entry", "string", "double"));
    mixin(UpdateMethods!("IConfiguration", "Entries", "Entry", "string", "string"));
    mixin(UpdateMethods!("IConfiguration", "Entries", "Entry", "string", "Json[string]"));
    mixin(UpdateMethods!("IConfiguration", "Entries", "Entry", "string", "Json[]"));
    mixin(UpdateMethods!("IConfiguration", "Entries", "Entry", "string", "Json"));

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
      return hasEntry(key)
        ? setEntry(key, value)
        : this;
    }

    unittest{
      auto config = MemoryConfiguration;

      // TODO 
    }
  // #endregion update

  // #region merge
    mixin(MergeMethods!("IConfiguration", "Entries", "Entry", "string", "bool"));
    mixin(MergeMethods!("IConfiguration", "Entries", "Entry", "string", "long"));
    mixin(MergeMethods!("IConfiguration", "Entries", "Entry", "string", "double"));
    mixin(MergeMethods!("IConfiguration", "Entries", "Entry", "string", "string"));
    mixin(MergeMethods!("IConfiguration", "Entries", "Entry", "string", "Json[string]"));
    mixin(MergeMethods!("IConfiguration", "Entries", "Entry", "string", "Json[]"));
    mixin(MergeMethods!("IConfiguration", "Entries", "Entry", "string", "Json"));

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
      return hasEntry(key)
        ? this
        : setEntry(key, value);
    }

    unittest{
      auto config = MemoryConfiguration;

      // TODO 
    }
  // #endregion merge
 
  // #region remove
      mixin(RemoveMethods!("IConfiguration", "Entries", "Entry", "string"));
    
      IConfiguration clearEntries() {
        removeEntries(entryKeys);
        return this;
      }

      abstract IConfiguration removeEntry(string key);

      unittest {
        auto config = MemoryConfiguration;
        // TODO
      }
  // #endregion remove

  // #region clone
    abstract IConfiguration clone(); 

    unittest {
      auto config = MemoryConfiguration;
      // TODO
    }
  // #endregion clone
}
