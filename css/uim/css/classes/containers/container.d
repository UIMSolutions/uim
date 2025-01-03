/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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
  bool opEquals(string css) {
    return toString == css;
  }

  bool opEquals(DCSSContainer obj) {
    return toString == obj.toString;
  }

  protected void init() {
  }

  override string toString() {
    return null;
  }
}

auto CSSContainer() {
  return new DCSSContainer();
}

unittest {
  // TODO
}
