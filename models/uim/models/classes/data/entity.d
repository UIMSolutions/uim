/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.entity;

import uim.models;

@safe:
class DEntityData : DData {
  mixin(DataThis!("EntityValue", "DEntity"));  

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    nameisNull(false)
      .isEntity(true);
  }

  protected DEntity _value;
  alias value = DData.value;
  void value(this O)(DEntity newValue) {
    _value = newValue;
     
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

  alias opEquals = DData.opEquals;

  override IData clone() {
    return EntityValue(attribute, toJson);
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
