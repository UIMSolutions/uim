/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.widgets.button;

import uim.views;
@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
} 

/**
 * Button input class
 *
 * This input class DCan be used to render button elements.
 * If you need to make basic submit inputs with type=submit,
 * use the Basic input widget.
 */
class DButtonWidget : DWidget {
  mixin(WidgetThis!("Button"));

  this(DStringContents mytemplates) {
    _stringContents = mytemplates;
  }

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  // Render a button.
  override string render(Json[string] renderData, IFormContext formContext) {
    renderData.merge("text", ""); // `text` The text of the button. Unlike all other form controls, buttons do not escape their contents by default.
    renderData.merge("type", "submit"); // `type` The button type defaults to "submit"
    renderData.merge("escapeTitle", true); // `escapeTitle` Set to false to disable escaping of button text.
    renderData.merge("escape", true); // `escape` Set to false to disable escaping of attributes.
    renderData.merge("templateVars", Json.emptyArray());

    return null;
    /* _stringContents.format("button", [
            "text": !renderData.isEmpty("escapeTitle") ? htmlAttributeEscape(renderData.getString("text")) : renderData.getString("text"),
            "templateVars": renderData.getString("templateVars"),
            "attrs": AttributeHelper.formatAttributes(renderData, ["text", "escapeTitle"]),
        ]); */
  }
}

mixin(WidgetCalls!("Button"));

unittest {
  assert(ButtonWidget);
}
