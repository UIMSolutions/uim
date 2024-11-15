module uim.views.classes.widgets.widget;

import uim.views;

@safe: 
class DWidget : UIMObject, IWidget { 
  mixin(WidgetThis!());

override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    configuration
      .merge(["name", "val"], Json(null))
      .merge("type", "text")
      .merge("escape", true)
      .merge("templateVars", Json.emptyArray);

    // TODO this.templater(HtmlTemplater);

    return true;
  }
  
    string render(string[string] data) {
        return "";
    }
}
