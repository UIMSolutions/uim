/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.errors.debugs.nodes;

@safe:
import uim.errors;

// Dump node for object properties.
class PropertyNode : IERRNode {
  private string myName;

  private string _visibility;

  private IERRNode _propertyValue;

  /**
    * Constructor
    *
    * theName - The property name
    * theVisibility - The visibility of the property.
    * theValue - The property value node.
    */
  this(string theName, string theVisibility, IERRNode theValue) {
    _name = theName;
    _visibility = theVisibility;
    _propertyValue = theValue;
  }

  /**
    * Get the value
    *
    * @return uim.errors.debugs.IERRNode
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

  IERRNode[] children() {
    return [this._propertyValue];
  }
}
