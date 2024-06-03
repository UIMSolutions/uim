/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.data.entity;

import uim.models;

@safe:
class DEntityData : DData {
  mixin(DataThis!("EntityData", "IEntity"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    isNull(false);
    isEntity(true);

    return true;
  }

  IEntity get() {
    return _value;
  }
  protected IEntity _value;
  IEntity opCall() {
    return get();
  }

  void set(IEntity newValue) {
    _value = newValue;
  }
  void opCall(IEntity newValue) {
    set(newValue);
  }

  override void set(string newValue) {
    if (newValue.isNull) {
      isNull(isNullable ? true : false);
      // set(null);
    } else {
      isNull(false);
      // set(to!IEntity(newValue));
    }
  }

  override void set(Json newValue) {
    if (newValue.isEmpty) {
      // set(null);
      isNull(isNullable ? true : false);
    } else {
      // set(newValue.get!`~jType~`);
      isNull(false);
    }
  }
    unittest {
      /* auto entity = SystemUser; // some kind of entity
      entity.set(entity);
      assert(entity.get.id == entity.id);*/
  }

/*  void set(IEntity newValue) {
    if (newValue.isNull) {
      isNull(isNullable ? true : false);
      _value = null;
    } else {
      isNull(false);
      _value = newValue;
    }
  } */

  /*  bool opEquals(IEntity otherValue) {
    return (get.id == otherValue.id);
  }

  int opCmp(IEntity otherValue) {
    /// TODO
    return 1;
  }  */

  alias opEquals = DData.opEquals;

  override IData clone() {
    return EntityData; // TODO (attribute, toJson);
  }

  alias toJson = DData.toJson;
  override Json toJson() {
    if (isNull)
      return Json(null);
    return Json(null); // Json(_value.toJson);
  }

  // EntityData converts to a JsonSTtring
  override string toString() {
    if (isNull)
      return null;
    return toJson.toString;
  }

}

mixin(DataCalls!("EntityData", "IEntity"));

version (test_uim_models) {
  unittest {
  }
}
