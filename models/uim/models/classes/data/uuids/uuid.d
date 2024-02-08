/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.uuids.uuid;

import uim.models;

@safe:
class DUUIDData : DData {
  mixin(DataThis!("UUIDData", "UUID"));  

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    nameisUUID(true);
  }

  protected UUID _value;  
  alias value = DData.value;
  UUID value() {
    return _value; 
  }
  void value(UUID newValue) {
    this.set(newValue);
     
  }

  override void set(Json newValue) {
    if (newValue.isEmpty) {
      if (!isNullable) return;

      this
        .isNull(true)
        .value(UUID());
      return;
    }

    if (newValue.type != Json.Type.string) {
      set(newValue.get!string);
    }
  }

  override void set(string newValue) {
    if (newValue is null) {
      if (!isNullable) return;

      this
        .isNull(true)
        .value(UUID());
      return;
    }

    if (newValue.isUUID) {
      this
        .isNull(false)
        .value(UUID(newValue));
    }
  }

  void set(UUID newValue) {
    if (newValue == UUID()) {
      if (!isNullable) return;

      this
        .isNull(true)
        .value(UUID());
      return;
    }    

    this.isNull(false);
    _value = newValue;
  }

  alias opEquals = DData.opEquals;
  override bool opEquals(UUID equalValue) {
    return (value == equalValue);
  }
  ///
  unittest {
    auto id = randomUUID;
    autvoid value = new DUUIDData(id);
    assert(value == id);
  }

  override IData clone() {
    return UUIDData(value);
  }

  override Json toJson() { 
    if (isNull) return Json(null); 
    return Json(this.value.toString); 
  }

  override string toString() { 
    if (isNull) return UUID().toString; 
    return this.value.toString; 
  }

  override void fromString(string newValue) { 
    this.value(newValue);
  }
}
mixin(DataCalls!("UUIDData", "UUID"));  

version(test_uim_models) { unittest {  
  auto uuid = randomUUID;
  assert(UUIDData(uuid).value == uuid);
  assert(UUIDData(randomUUID).value != uuid);

  assert(UUIDData.value(uuid).value == uuid);
  assert(UUIDData.value(randomUUID).value != uuid);

  assert(UUIDData.value(uuid.toString).value == uuid);
  assert(UUIDData.value(randomUUID.toString).value != uuid);

  assert(UUIDData.value(Json(uuid.toString)).value == uuid);
  assert(UUIDData.value(Json(randomUUID.toString)).value != uuid);

  assert(UUIDData(uuid).toString == uuid.toString);
  assert(UUIDData(randomUUID).toString != uuid.toString);

  assert(UUIDData(uuid).toJson == Json(uuid.toString));
  assert(UUIDData(randomUUID).toJson != Json(uuid.toString));
}}

///
unittest {
  auto id = randomUUID;
  auto uuiDData = new DUUIDData(id);

  assert(uuiDData == id);
  assert(uuiDData != randomUUID);
}
