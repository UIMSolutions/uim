/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.nodes.array_;

@safe:
import uim.errors;

// Dump node for Array values.
class DArrayErrorNode : DErrorNode {
  mixin(ErrorNodeThis!("Array"));

  this(DArrayItemErrorNode[] nodes = null) {
    /* _items = null;
    add(nodes); */
  }

  // Add nodes
  void add(DArrayItemErrorNode[] nodes...) {
    add(nodes);
  }

  void add(DArrayItemErrorNode[] nodes) {
    // foreach (myItem; nodes) { _items ~= myItem; }
  }

  // Get the contained items
  string value() {
    return null;
    // TODO return _items.map!(item => item.value).join(", ");
  }
}
