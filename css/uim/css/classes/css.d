/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.css.classes.css;

import uim.css;

@safe:
class DCSS {
  this() {}
  this(string newContent) { this.content(newContent); }

  // Resulting contet
  mixin(XString!("content"));
  version(test_uim_css) { unittest {}}

  O rule(this O)(string selector, string[string] values) {
    return content("%s%s".format(selector, values.toCss));
  }
  unittest {
// TODO
}

  // Compare with toString result
  bool opEquals(string txt) { return (txt == toString); }

  string toHTML() {
    return `<style>`~content~`</style>`;
  }

  override string toString() {
    return content;
  }
}
auto CSS() { return new DCSS(); }
auto CSS(string newContent) { return new DCSS(newContent); }

unittest {
  assert(CSS("test").toHTML == `<style>test</style>`);
}