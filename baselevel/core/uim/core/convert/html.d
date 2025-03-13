module uim.core.convert.html;

import uim.core;

@safe:

string toHTML(string tag) {
  return "<%s>".format(tag);
}

/* string toHTML(Json json) {
  if (json.isString) {
    return "<%s>".format(tag);
  }
  // TODO
  return null; 
}
 */