/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.nodes.reference;

@safe:
import uim.errors;

// <b>Dump nodes for class references</b> to prevent cyclic references from being emitted multiple times.
// A reference node can be used after an object has been emitted in the first.
class DReferenceErrorNode : DErrorNode {
  mixin(ErrorNodeThis!("Reference"));

  this(string nameOfClass, int idOfClass) {
    _classname = nameOfClass;
    _id = idOfClass;
  }

  // #region Fields
  private string _classname;
  // Get the class name/value
  override Json value() {
    return Json(_classname);
  }

  private int _id;
  // Get the reference id for this node.
  int id() {
    return _id;
  }
  // #endregion fields
}
