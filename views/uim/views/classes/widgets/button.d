module uim.views.classes.widgets.button;

import uim.views;

@safe:

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
    override string render(Json[string] renderData, IContext formContext) {
        Json[string] updatedData = renderData.merge([
            // `text` The text of the button. Unlike all other form controls, buttons do not escape their contents by default.
            "text": "".toJson,
            // `type` The button type defaults to "submit".
            "type": Json("submit"),
            // `escapeTitle` Set to false to disable escaping of button text.
            "escapeTitle": true.toJson,
            // `escape` Set to false to disable escaping of attributes.
            "escape": true.toJson,
            "templateVars": Json.emptyArray(),
        ]);

        return null; 
        _stringContents.format("button", [
            "text": !updatedData.isEmpty("escapeTitle") ? htmlAttributeEscape(updatedData.getString("text")) : updatedData.getString("text"),
            "templateVars": updatedData.getString("templateVars"),
            "attrs": _stringContents.formatAttributes(updatedData, ["text", "escapeTitle"]),
        ]);
    }
}
mixin(WidgetCalls!("Button"));

