/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.data.maps.map;

import uim.models;

@safe:
class DMapData : DData {
  mixin(DataThis!("Map"));

  protected IData[string] _items;

  /* void opIndexAssign(IData value, string key) {
    _items[key] = value;
  }

  void opIndexAssign(bool value, string key) {
    _items[key] = BooleanData(value);
  }

  void opIndexAssign(long value, string key) {
    _items[key] = LongData(value);
  }

  void opIndexAssign(double value, string key) {
    _items[key] = NumberData(value);
  }

  void opIndexAssign(string value, string key) {
    _items[key] = StringData(value);

  } * /

  void opIndexAssign(UUID value, string key) {
    // TODO
    /*
    if (containscorrectKey(key)) {
      _items[key].set(value.toString);
    } else {
      _items[key] = new DUUIDData(value);
    } * /
  }

  void opIndexAssign(IData[] values, string key) {
    // TODO
    /*
    if (containscorrectKey(key)) {
      _items[key] = new DArrayData(values);
    } else {
      _items[key] = new DArrayData(values);
    } * /
  } */

  // #region equal
  // mixin(ScalarDataOpEquals!(null));

  /* override bool isEqual(IData[string] checkData) {
    return false;
    // TODO
    /*
    return checkData.byKeyValue
      .all!(kv => hascorrectKey(key) && data(kv.key).isEqual(kv.value)); * /
  } */

  /*   override bool isEqual(IData checkData) {
    return false;
  } */

  /*   override bool isEqual(Json checkValue) {
    if (checkValue.isObject) {
      return checkValue.byKeyValue
        .all!(kv => hascorrectKey(key) && data(kv.key).isEqual(kv.value));
    }
    return false;
  }

  override bool isEqual(string checkValue) {
    return false;
  } */
  // #endregion equal

  /*   override IData data(string key) {
    return _items.get(key, null);
  } */

  ///
  // unittest {
  /* auto boolDataTrue = BooleanData;
    boolDataTrue.set(true);
    auto boolDataIstrue = BooleanData;
    boolDataIstrue.set(true);
    auto boolDataNottrue = BooleanData;
    boolDataNottrue.set(false);
  // TODO assert(boolDataTrue == true.toJson);
  // TODO assert(boolDataTrue == "true");
  // TODO assert(boolDataTrue == true);

  // TODO assert(boolDataTrue == true.toJson);
  // TODO assert(boolDataTrue != "false");
  }
  // #endregion equal

/*   override IData opIndex(string key) {
    return _items.get(key, null);
  }
 */
  override bool isEmpty() {
    return (_items.length == 0);
  }

  override size_t length() {
    return _items.length;
  }

  string[] _keys() {
    return _items.keys;
  }

  override IData clone() {
    return null; // NullData; // MapValue!string(attribute, toJson);
  }

  /* alias toJson = DData.toJson;
  override Json toJson() {
    Json results = Json.emptyObject;
    /* _items.byKeyValue.each!(kv => results[kv.key] = kv.value.toJson); * /

    return results;
  } */

  override string toString() {
    string content; /*  = _items.byKeyValue
      .map!(kv => "%s:%s".format(kv.key, kv.value))
      .join(","); */

    return "[" ~ content ~ "]";
  }
}

mixin(DataCalls!("Map"));

///
unittest {
  /* auto stringMap = MapValue!string();
  stringMap["key1"] = Json("value1");

// TODO assert(stringMap["key1"].toString == "value1");
// TODO assert(cast(DStringData) stringMap["key1"]);
// TODO assert(!cast(DBooleanData) stringMap["key1"]);

  stringMap["key2"] = "value2";
// TODO assert(stringMap["key2"].toString == "value2");

  stringMap["key3"] = true;
// TODO assert(stringMap["key3"].toString == "true");

  stringMap["key4"] = 100;
// TODO assert(stringMap["key4"].toString == "100");

  stringMap["key5"] = 100.1;
// TODO assert(stringMap["key5"].toString == "100.1");

  stringMap["key6"] = [Json("v1"), Json("v2")];

// TODO assert(stringMap.toJson.toString == `{"key1": "value1","key6": null,"key2": "value2","key3": true,"key5": 100.1,"key4": 100}`); */
}
