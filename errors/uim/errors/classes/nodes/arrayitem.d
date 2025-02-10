/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.nodes.arrayitem;

@safe:
import uim.errors;

// Dump node for Array Items.
class DArrayItemErrorNode : DErrorNode {
  mixin(ErrorNodeThis!("ArrayItem"));

  private IErrorNode _key;
  private IErrorNode _value;

  /**
    * aKey - The node for the item key
    * aValue - The node for the array value
    */
  this(IErrorNode aKey, IErrorNode aValue) {
    super();
    _key = aKey;
    // _value = aValue;
  }

  // Get value
/*   @property IErrorNode value() {
    return _value;
  } */

  // Get the key
  @property IErrorNode key() {
    return _key;
  }

/*   IErrorNode[] getChildren() {
    return [value];
  } */
}
