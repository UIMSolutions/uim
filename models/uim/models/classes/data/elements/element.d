/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.values.elements.element;

import uim.models;

@safe:
class DElementData: DData {
  mixin(DataThis!("ElementValue", "DElement"));    

  // Initialization hook method.
  override bool initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .isNull(false);
  }

  protected DElement _value;
  alias value = DData.value;
  O value(this O)(DElement newValue) {
    _value = newValue;
    return cast(O)this; 
  }
  DElement value() {
    return _value; 
  }
  version(test_uim_models) { unittest {    
    auto Element = SystemUser; // some kind of Element
    assert(ElementValue.value(Element).value.id == Element.id);
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
  bool opEquals(DElementValue otherValue) {
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

  override DData copy() {
    return ElementValue(attribute, toJson);
  }
  override DData dup() {
    return copy;
  }

  override Json toJson() { 
    if (isNull) return Json(null); 
    return this.value.toJson; 
  }

  // ElementValue converts to a JsonSTtring
  override string toString() { 
    if (isNull) return null; 
    return this.value.toString; 
  }

  override void fromString(string newValue) { 
    /// TODO this.value(newValue);
  }
}
mixin(ValueCalls!("ElementValue"));  

version(test_uim_models) { unittest {  
  assert(ElementValue);
}}
