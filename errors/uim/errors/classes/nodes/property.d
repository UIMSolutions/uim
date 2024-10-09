/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.nodes.property; 

@safe:
import uim.errors;

// Dump node for object properties.
class DPropertyErrorNode : DErrorNode {
  mixin(ErrorNodeThis!("Property"));

  private string _name;

  private string _visibility;

  private IErrorNode _propertyValue;

  this(string propertyName, string propertyVisibility, IErrorNode propertyErrorNode) {
    _name = propertyName;
    _visibility = propertyVisibility;
    _propertyValue = propertyErrorNode;
  }

  // Get the value
  IErrorNode value() {
    return _propertyValue.value;
  }

  // Get the property visibility
  string visibility() {
    return _visibility;
  }

/*   // Get the property name
  string name() {
    return _name;
  } */

  override IErrorNode[] children() {
    return [this._propertyValue];
  }
}
