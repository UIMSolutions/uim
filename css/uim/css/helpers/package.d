module uim.css.helpers;

import uim.css;

string toCSS(STRINGAA values, bool sorted = false) {
  string[] keys = sorted ? values.keys.sort.array : values.keys;

  return keys.map!(key => "%s:%s;".format(key, values[key])).join;
}

unittest {
  assert(toCSS(["a":  "b"]) == `a:b;`);
  assert(toCSS(["a":  "b"], true) == `a:b;`);

  assert(toCSS(["a":  "b", "c":  "d"]) == `c:d;a:b;`);
  assert(toCSS(["a":  "b", "c":  "d"], true) == `a:b;c:d;`);
}

string toCSS(STRINGAA[string] values, bool shouldSort = false) {
  string[] keys = shouldSort ? values.keys.sort.array : values.keys;

  return keys.map!(key => toCSS(key, values[key])).join;
}

string toCSS(string selector, STRINGAA values, bool shouldSort = false) {
  string[] keys = shouldSort ? values.keys.sort.array : values.keys;

  string[] results = keys.map!(key => "%s:%s;".format(key, values[key])).array;
  return "%s{%s}".format(selector, results);
}

version (test_uim_css) {
  unittest {
  }
}
version (test_uim_css) {
  unittest {
  }
}

string cssBlock(string content) {
  return "{" ~ content ~ "}";
}
///
unittest {
  assert(cssBlock("test") == "{test}");
  assert(cssBlock("test") != "[test]");
}
