/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.errors.classes.nodes.property;

@safe:
import uim.errors;

// Dump node for object properties.
class DPropertyNode : IErrorNode {
  private string _name;

  private string _visibility;

  private IErrorNode _propertyValue;

  /**
    * Constructor
    *
    * theName - The property name
    * theVisibility - The visibility of the property.
    * theValue - The property value node.
    */
  this(string theName, string theVisibility, IErrorNode theValue) {
    _name = theName;
    _visibility = theVisibility;
    _propertyValue = theValue;
  }

  /**
    * Get the value
    *
    * @return uim.errors.debugs.IErrorNode
    */
  string value() {
    return _propertyValue.value;
  }

  // Get the property visibility
  string visibility() {
    return _visibility;
  }

  // Get the property name
  string name() {
    return _name;
  }

  IErrorNode[] children() {
    return [this._propertyValue];
  }
}
