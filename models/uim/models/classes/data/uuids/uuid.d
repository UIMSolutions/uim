/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.values.uuids.uuid;

import uim.models;

@safe:
class DUUIDValue : DValue {
  mixin(ValueThis!("UUIDValue", "UUID"));  

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .isUUID(true);
  }

  protected UUID _value;  
  alias value = DValue.value;
  UUID value() {
    return _value; 
  }
  O value(this O)(UUID newValue) {
    this.set(newValue);
    return cast(O)this; 
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

  alias opEquals = DValue.opEquals;
  override bool opEquals(UUID equalValue) {
    return (value == equalValue);
  }
  ///
  unittest {
    auto id = randomUUID;
    auto value = new DUUIDValue(id);
    assert(value == id);
  }

  override DValue copy() {
    return UUIDValue(value);
  }
  override DValue dup() {
    return UUIDValue(value);
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
mixin(ValueCalls!("UUIDValue", "UUID"));  

version(test_uim_models) { unittest {  
  auto uuid = randomUUID;
  assert(UUIDValue(uuid).value == uuid);
  assert(UUIDValue(randomUUID).value != uuid);

  assert(UUIDValue.value(uuid).value == uuid);
  assert(UUIDValue.value(randomUUID).value != uuid);

  assert(UUIDValue.value(uuid.toString).value == uuid);
  assert(UUIDValue.value(randomUUID.toString).value != uuid);

  assert(UUIDValue.value(Json(uuid.toString)).value == uuid);
  assert(UUIDValue.value(Json(randomUUID.toString)).value != uuid);

  assert(UUIDValue(uuid).toString == uuid.toString);
  assert(UUIDValue(randomUUID).toString != uuid.toString);

  assert(UUIDValue(uuid).toJson == Json(uuid.toString));
  assert(UUIDValue(randomUUID).toJson != Json(uuid.toString));
}}

///
unittest {
  auto id = randomUUID;
  auto uuidValue = new DUUIDValue(id);

  assert(uuidValue == id);
  assert(uuidValue != randomUUID);
}
