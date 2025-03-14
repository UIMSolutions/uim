module uim.core.convert.html;

import uim.core;

@safe:

string toHTML(string tag) {
  return "<%s>".format(tag);
}
unittest {
  assert("test".toHTML == "<test>");
}

/* string toHTML(Json json) {
  if (json.isString) {
    return "<%s>".format(tag);
  }
  // TODO
  return null; 
}
 */

 string toHTML(T)(T[string] items, bool sorted = NOTSORTED) {
  return items.sortKeys(sorted ? "ASC" : "NONE")
    .map!(key => `%s="%s"`.format(key, items[key]))
    .join(" ");
}

unittest {
  writeln(__FILE__, "/", __LINE__);
  // assert(["a": 1, "b": 2].toHTML(SORTED) == `a="1" b="2"`);
}
