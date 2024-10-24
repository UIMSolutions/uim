/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.nodes.special;

import uim.errors;

@safe:

// Debug node for special messages like errors or recursion warnings.
class DSpecialErrorNode : IErrorNode {
  mixin(ErrorNodeThis!("Special"));

  private string _value;

  /**
    * Params:
    * string avalue The message/value to include in dump results.
    */
  this(string aValue) {
    _value = aValue;
  }

  // Get the message/value
  string value() {
    return _value;
  }
}
