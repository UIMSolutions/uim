/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.data.uuids.uuid;

import uim.models;

@safe:
class DUUIDData : DData {
  mixin(DataThis!("UUID"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isUUID(true);

    return true;
  }
/* 
  protected UUID _value;
  @property UUID get() {
    return _value;
  }

  override void set(Json newValue) {
    if (newValue.isEmpty) {
      if (!is nullable)
        return;

      isNull(true);
      _value = UUID();
    }

    if (newValue.type != Json.Type.string) {
      set(newValue.get!string);
    }
  }

  override void set(string newValue) {
    if (newValue.isNull) {
      if (!is nullable)
        return;

      isNull(true);
      _value = UUID();
    }

    if (newValue.isUUID) {
      isNull(false);
      _value = UUID(newValue);
    }
  }

  void set(UUID newValue) {
    if (newValue == UUID()) {
      if (!is nullable)
        return;

      isNull(true);
      _value = UUID();
    }

    isNull(false);
    _value = newValue;
  } */

 /*  alias opEquals = DData.opEquals;
  /* override  * /bool opEquals(UUID equalValue) {
    return (get == equalValue);
  }
  ///
  unittest {
    /* auto id = randomUUID;
    auto value = new DUUIDData(id); 
    assert(value == id);* /
  }

  override IData clone() {
    return UUIDData(_value);
  }

  alias toJson = DData.toJson;
  override Json toJson() {
    if (isNull)
      return Json(null);
    return Json(toString);
  }

  override string toString() {
    if (isNull)
      return UUID().toString;
    return _value.toString;
  } */
}

mixin(DataCalls!("UUID"));

version (test_uim_models) {
  unittest {
    // TODO
    /* 
    auto uuid = randomUUID;
    assert(UUIDData(uuid).get == uuid);
    assert(UUIDData(randomUUID).value != uuid);

    assert(UUIDData._value = UUID).get == uuid);
    assert(UUIDData.value(randomUUID).value != uuid);

    assert(UUIDData._value = UUID.toString).get == uuid);
    assert(UUIDData.value(randomUUID.toString).value != uuid);

    assert(UUIDData.set(Json(uuid.toString)).get == uuid);
    assert(UUIDData.set(Json(randomUUID.toString)).value != uuid);

    assert(UUIDData(uuid).toString == uuid.toString);
    assert(UUIDData(randomUUID).toString != uuid.toString);

    assert(UUIDData(uuid).toJson == Json(uuid.toString));
    assert(UUIDData(randomUUID).toJson != Json(uuid.toString));
    */
  }
}

///
unittest {
  /* auto id = randomUUID;
  auto uuiDData = new DUUIDData(id);

  assert(uuiDData == id);
  assert(uuiDData != randomUUID); */
}