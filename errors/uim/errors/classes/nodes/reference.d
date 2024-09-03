/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
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
class DReferenceNode : IErrorNode {
  /**
    
    *
    * aclassname - The class name
    * anId - The id of the referenced class.
    */
  this(string aclassname, int anId) {
      _classname = aclassname;
      _id = anId;
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
