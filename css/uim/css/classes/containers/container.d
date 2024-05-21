module uim.css.classes.containers.container;

import uim.css;
@safe:

class DCSSContainer {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

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

version(test_uim_css) { unittest {
  // TODO
}}