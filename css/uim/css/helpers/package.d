module uim.css.helpers;

import uim.css;

string toCSS(string[string] values, bool sorted = false) {
  string results;
  if (sorted) foreach(key; values.keys.sort) results ~= "%s:%s;".format(key, values[key]);
  else foreach(key, value; values) results ~= "%s:%s;".format(key, value);
  return results;
}
version(test_uim_css) { unittest {
  assert(toCSS(["a":"b"]) == `a:b;`);
  assert(toCSS(["a":"b"], true) == `a:b;`);

  assert(toCSS(["a":"b", "c":"d"]) == `c:d;a:b;`);
  assert(toCSS(["a":"b", "c":"d"], true) == `a:b;c:d;`);
}}

string toCSS(string selector, string[string] values, bool sorted = false) {
  string results;
  if (sorted) foreach(key; values.keys.sort) results ~= "%s:%s;".format(key, values[key]);
  else foreach(key, value; values) results ~= "%s:%s;".format(key, value);
  return "%s{%s}".format(selector, toCSS(values, sorted));
}
version(test_uim_css) { unittest {}}

string toCSS(string[string][string] values, bool sorted = false) {
  string results;
  if (sorted) foreach(key; values.keys.sort) results ~= toCSS(key, values[key]);
  else foreach(key, value; values) results ~= toCSS(key, value);
  return results;
}
version(test_uim_css) { unittest {}}

string cssBlock(string content) { return "{"~content~"}"; }
