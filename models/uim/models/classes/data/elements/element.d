/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.elements.element;

import uim.models;

@safe:
class DElementData : DData {
  mixin(DataThis!("ElementData", "DElement"));    

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    nameisNull(false);
  }

  protected DElement _value;
  alias value = DData.value;
  void value(this O)(DElement newValue) {
    _value = newValue;
     
  }
  DElement value() {
    return _value; 
  }
  version(test_uim_models) { unittest {    
    auto Element = SystemUser; // some kind of Element
    assert(ElementData.value(Element).value.id == Element.id);
  }}

  override void set(string newValue) {
    /// TODO
  }  

  override void set(Json newValue) {
    /// TODO
  }

  void set(DElement newValue) {
    if (newValue) {
      this.isNull(false);
      _value = newValue;
      return;
    } 

    if (isNullable) {
      this.isNull(true);
      _value = null;      
    }
  }

  alias opEquals = DData.opEquals;
  bool opEquals(DElementData otherValue) {
    string left = value.toString;
    string right = otherValue.value.toString;
    return (left == right);
  }

  bool opEquals(DElement otherValue) {
    return (value.toString == otherValue.toString);
  }

  override bool opEquals(string otherValue) {
    return (value.toString == otherValue);
  }

/*   int opCmp(DElement otherValue) {
    /// TODO
    return 1;
  }  */

  override IData clone() {
    return ElementData(attribute, toJson);
  }

  override Json toJson() { 
    if (isNull) return Json(null); 
    return this.value.toJson; 
  }

  // ElementData converts to a JsonSTtring
  override string toString() { 
    if (isNull) return null; 
    return this.value.toString; 
  }

  override void fromString(string newValue) { 
    /// TODO this.value(newValue);
  }
}
mixin(ValueCalls!("ElementData"));  

version(test_uim_models) { unittest {  
  assert(ElementData);
}}
