module uim.views.classes.views.view;

import uim.views;

@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DView : UIMObject, IView {
  mixin(ViewThis!());

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

/*     _eventMap = [
      "View.beforeRenderFile": "beforeRenderFile",
      "View.afterRenderFile": "afterRenderFile",
      "View.beforeRender": "beforeRender",
      "View.afterRender": "afterRender",
      "View.beforeLayout": "beforeLayout",
      "View.afterLayout": "afterLayout",
    ]; */

    return true;
  }

  string currentType() {
    return null;
  }

  string[] blockNames() {
    return null;
  }

  IView enableAutoLayout(bool enable = true) {
    return null;
  }

  IView disableAutoLayout() {
    return null;
  }

  string render(string[string] data) {
    return "";
  }
}
