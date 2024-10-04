/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.classes.nodes.reference;

@safe:
import uim.errors;

/**
 * Dump node for class references.
 *
 * To prevent cyclic references from being output multiple times
 * a reference node can be used after an object has been seen the
 * first time.
 */
class DReferenceNode : DErrorNode {
  this(string nameOfClass, int idOfClass) {
      _classname = nameOfClass;
      _id = idOfClass;
  }

  // #region Fields
    private string _classname;
    // Get the class name/value
    string value() {
        return _classname;
    }

    private int _id;
    // Get the reference id for this node.
    int id() {
        return _id;
    }
  // #endregion fields

  IErrorNode[] getChildren() {
      return [];
  }
}
