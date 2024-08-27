module uim.css.classes.containers.container;

import uim.css;
@safe:

class DCSSContainer : UIMObject {

    this() {
        super();
    }

    this(Json[string] initData) {
        super(initData);
    }

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
return false;
}

        return true;
    }

  DCSSObj[] _cssItems;

  alias opEquals = Object.opEquals;
  bool opEquals(string css) { return toString == css; }
	bool opEquals(DCSSContainer obj) { return toString == obj.toString; }

	protected void init() { }

  override string toString() {
    return null;
  }
}
auto CSSContainer() { return new DCSSContainer(); }

unittest {
  // TODO
}