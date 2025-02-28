/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.templaters.templater;

import uim.views;
@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
} 

class DTemplater : UIMObject {
  mixin(TemplaterThis!());

  protected STRINGAA _templates;

  string get(string key) {
    return _templates.get(key, null);
  }

  string render(string key, string[string] options) {
    return get(key).doubleMustache(options);
  }

  string render(string key, Json[string] options) {
    return get(key).doubleMustache(options);
  }
}
