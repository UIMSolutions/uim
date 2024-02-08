/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.values.entity;

import uim.models;

@safe:
class DEntityValue : DValue {
  mixin(ValueThis!("EntityValue", "DEntity"));  

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .isNull(false)
      .isEntity(true);
  }

  protected DEntity _value;
  alias value = DValue.value;
  O value(this O)(DEntity newValue) {
    _value = newValue;
    return cast(O)this; 
  }
  DEntity value() {
    return _value; 
  }
  version(test_uim_eDEntityntities) {
    unittest {    
      auto entity = SystemUser; // some kind of entity
      assert(EntityValue.value(entity).value.id == entity.id);
  }}

  protected void set(DEntity newValue) {
    if (newValue is null) { 
      this.isNull(isNullable ? true : false); 
      _value = null; }
    else {
      this.isNull(false);
      _value = newValue; 
    }
  }  

  override protected void set(string newValue) {
    /// TODO
  }  

  override protected void set(Json newValue) {
    /// TODO
  }

/*   bool opEquals(DEntity otherValue) {
    return (this.value.id == otherValue.id);
  }

  int opCmp(DEntity otherValue) {
    /// TODO
    return 1;
  }  */

  alias opEquals = DValue.opEquals;

  override DValue copy() {
    return EntityValue(attribute, toJson);
  }
  override DValue dup() {
    return copy;
  }

  override Json toJson() { 
    if (isNull) return Json(null); 
    return this.value.toJson; 
  }

  // EntityValue converts to a JsonSTtring
  override string toString() { 
    if (isNull) return null; 
    return toJson.toString; 
  }

  override void fromString(string newValue) { 
    /// TODO this.value(newValue);
  }
}
mixin(ValueCalls!("EntityValue", "DEntity"));  

version(test_uim_models) { unittest {  
}}
