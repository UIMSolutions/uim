module uim.errors.classes.nodes.special;

import uim.errors;

@safe:

/*
 * Debug node for special messages like errors or recursion warnings.
 */
class DSpecialNode : IErrorNode {
  private string avalue;

  /**
    * Constructor
    * Params:
    * string avalue The message/value to include in dump results.
    */
  this(string avalue) {
      this.value = aValue;
  }

  /**
    * Get the message/value
    */
  string getValue() {
      return this.value;
  }


  array getChildren() {
      return null;
  }
}
