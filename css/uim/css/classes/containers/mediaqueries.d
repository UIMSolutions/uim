module uim.css.classes.containers.mediaqueries;

import uim.css;
@safe:

class DCSSMediaQueries {
  this() {
    _queries["default"] = CSSMediaQuery;
  }

  protected DCSSMediaQuery[string] _queries;

  auto query(string queryName = null) {
    if (queryName) return _queries.get(queryName, null);
    return _queries.get("default", null); }
  version(test_uim_css) { unittest {
      /// TODO
    }}

  O query(this O)(string queryName, string condition) {
    if (queryName !in _queries) _queries[queryName] = CSSMediaQuery(condition);
    return cast(DO)this; }
  version(test_uim_css) { unittest {
      /// TODO
    }}

  auto rule(this O)(string name) {
    return _queries["default"].rule(name, properties); }
  version(test_uim_css) { unittest {
      /// TODO
    }}

  O rule(this O)(string name, string properties) {
    _queries["default"].rule(name, properties); 
    return cast(DO)this; }
  version(test_uim_css) { unittest {
      /// TODO
    }}

  O rule(this O)(string queryName, string name, string properties) {
    if (queryName in _queries) _queries[query].rule(name, properties); 
    return cast(DO)this; }
  version(test_uim_css) { unittest {
      /// TODO
    }}

 O removeRule(this O)(string name) {
    _queries["default"].removeRule(name); 
    return cast(DO)this; }
  version(test_uim_css) { unittest {
      /// TODO
    }}

  O removeRule(this O)(string queryName, string name) {
    if (queryName in _queries) _queries[queryName].removeRule(name); 
    return cast(DO)this; }
  version(test_uim_css) { unittest {
      /// TODO
    }}

  override string toString() {
    string result;

    foreach(query; _queries.byValue) if (query) result ~= query.toString; 

    return result;
  } 
  version(test_uim_css) { unittest {
      /// TODO
    }}

  string toString(string[] queryNames) {
    string result;
    foreach(query; _queries.byValue) if (query) result ~= query.toString;     
    return result;
  } 
  version(test_uim_css) { unittest {
      /// TODO
    }}
}
auto CSSMediaQueries() { return new DCSSMediaQueries; }
