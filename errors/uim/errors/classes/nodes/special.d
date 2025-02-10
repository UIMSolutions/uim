/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.nodes.special;

import uim.errors;

@safe:

// Debug node for special messages like errors or recursion warnings.
class DSpecialErrorNode : DErrorNode {
  mixin(ErrorNodeThis!("Special"));

  this(string value) {
    _value = Json(value);
  }
}
