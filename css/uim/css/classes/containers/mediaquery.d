module uim.css.classes.containers.mediaquery;

import uim.css;
@safe:

class DCSSMediaQuery {
  this() { }
  this(string newCondition) { 
    this(); 
    this
    .condition(newCondition); }

  mixin(OProperty!("string", "condition"));

  protected STRINGAA _rules;

  auto rule(this O)(string selector) {
    return _rules.get(selector, null); }
  version(test_uim_css) { unittest {
      /// TODO
    }}

  O rule(this O)(string selector, string properties) {
    _rules[selector] = properties;
    return cast(O)this; }
  version(test_uim_css) { unittest {
      /// TODO
    }}

  O removeRule(this O)(string selector) {
    _rules.remove(selector); 
    return cast(O)this; }
  version(test_uim_css) { unittest {
      /// TODO
    }}

  auto opIndex(string selector) {
    return rule(selector); }
  version(test_uim_css) { unittest {
      /// TODO
    }}

  O opIndexAssign(this O)(string selector, string properties) {
    rule(selector, properties);
    return cast(O)this; }
  version(test_uim_css) { unittest {
      /// TODO
    }}

  override string toString() {
    string result;

    foreach(sel, props; _rules) result ~= sel~"{"~props~"}";

    if (condition) return "@media "~condition~"{"~result~"}";
    else return result; }
  version(test_uim_css) { unittest {
      /// TODO
    }}
}
auto CSSMediaQuery() { return new DCSSMediaQuery; }
auto CSSMediaQuery(string condition) { return new DCSSMediaQuery(condition); }
