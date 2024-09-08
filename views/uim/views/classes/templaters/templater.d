module uim.views.classes.templaters.templater;

import uim.views;

@safe:
unittest {
  writeln("-----  ", __MODULE__, "\t  -----");
}

class DTemplater : UIMObject {
  mixin(TemplaterThis!());

  protected STRINGAA _templates;

  string get(string key) {
    return _templates.get(key, null);
  }

  string render(string key, STRINGAA options) {
    return get(key).doubleMustache(options);
  }

  string render(string key, Json[string] options) {
    return get(key).doubleMustache(options);
  }
}
