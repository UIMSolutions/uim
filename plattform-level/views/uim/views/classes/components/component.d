module uim.views.classes.components.component;

import uim.views;
@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DViewComponent : UIMObject, IViewComponent {
  mixin(ViewThis!());

  string render(string[string] data) {
    return "";
  }
}
