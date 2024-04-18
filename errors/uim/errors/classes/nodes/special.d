module uim.errors.classes.nodes.special;

import uim.errors;

@safe:

/*
 * Debug node for special messages like errors or recursion warnings.
 */
class DSpecialNode : IErrorNode {
  private string _value;

  /**
    * Constructor
    * Params:
    * string avalue The message/value to include in dump results.
    */
  this(string aValue) {
      _value = aValue;
  }

  // Get the message/value
  string getValue() {
      return _value;
  }

  /* 
  array getChildren() {
      return null;
  } */
}
