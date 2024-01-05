module uim.css.classes.containers.container;

import uim.css;
@safe:

class DCSSContainer {
  DCSSObj[] _cssItems;

  alias opEquals = Object.opEquals;
  bool opEquals(string css) { return toString == css; }
	bool opEquals(DCSSContainer obj) { return toString == obj.toString; }

	protected void init() { }

  override string toString() {
    return "";
  }
}
auto CSSContainer() { return new DCSSContainer(); }

version(test_uim_css) { unittest {
  // TODO
}}