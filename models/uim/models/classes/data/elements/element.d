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
    if (!super.initialize(configData)) {
      return false;
    }

    isNull(false);

    return true;
  }

  version (test_uim_models) {
    unittest {
      auto Element = SystemUser; // some kind of Element
      auto data = ElementData(Element);
      assert(data.get.id == Element.id);
    }
  }

  // #region Getter & Setter
  DElement get() {
    return _value;
  }

  void set(DElement newValue) {
    _value = newValue;
  }

  protected DElement _value;
  DElement opCall() {
    return get();
  }

  void opCall(DElement newValue) {
    set(newValue);
  }

  override void set(string newValue) {
    if (newValue is null) {
      isNull(isNullable ? true : false);
      // set(null);
    } else {
      isNull(false);
      // set(to!DElement(newValue));
    }
  }

  override void set(Json newValue) {
    if (newValue.isEmpty) {
      set(null);
      isNull(isNullable ? true : false);
    } else {
      // set(newValue.get!string);
      isNull(false);
    }
  }
  // #endregion Getter & Setter


  alias opEquals = DData.opEquals;
  bool opEquals(DElementData otherValue) {
    string left = get.toString;
    string right = otherValue.get.toString;
    return (left == right);
  }

  bool opEquals(DElement otherValue) {
    return (get.toString == otherValue.toString);
  }

  override bool opEquals(string otherValue) {
    return (get.toString == otherValue);
  }

  /*   int opCmp(DElement otherValue) {
    /// TODO
    return 1;
  }  */

  override IData clone() {
    return ElementData; // TODO (attribute, toJson);
  }

  alias toJson = DData.toJson;
  override Json toJson() {
    if (isNull)
      return Json(null);
    return get.toJson;
  }

  // ElementData converts to a JsonSTtring
  override string toString() {
    if (isNull)
      return null;
    return get.toString;
  }

}

mixin(DataCalls!("ElementData"));

version (test_uim_models) {
  unittest {
    assert(ElementData);
  }
}
