module uim.css.classes.css;

import uim.css;

@safe:
class DCSS {
  this() {}
  this(string newContent) { this.content(newContent); }

  // Resulting contet
  mixin(XString!("content"));
  version(test_uim_css) { unittest {}}

  O rule(this O)(string selector, STRINGAA values) {
    return content("%s%s".format(selector, values.toCss));
  }
  version(test_uim_css) { unittest {}}

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