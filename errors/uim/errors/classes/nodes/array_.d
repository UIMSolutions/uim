/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.errors.classes.nodes.array_;

@safe:
import uim.errors;

// Dump node for Array values.
class DArrayErrorNode : IErrorNode {
  private IErrorNode[] _items;

  /**
    * Constructor
    * someItems - The items for the array
    */
  this(DArrayItemErrorNode[] nodes = null) {
    _items = null;
    this.add(nodes);
  }

  // Add nodes
  void add(DArrayItemErrorNode[] nodes...) {
    this.add(nodes);
  }

  void add(DArrayItemErrorNode[] nodes) {
    foreach (myItem; nodes) { _items ~= myItem; }
  }

  // Get the contained items
  string value() {
    return _items.map!(item => item.value).join(", ");
  }

  // Get Item nodes
  IErrorNode[] children() {
    return _items;
  }
}
