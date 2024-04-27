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
        Json[string] mergedData = renderData.merge([
            // `text` The text of the button. Unlike all other form controls, buttons do not escape their contents by default.
            "text": StringData(""),
            // `type` The button type defaults to "submit".
            "type": StringData("submit"),
            // `escapeTitle` Set to false to disable escaping of button text.
            "escapeTitle": BooleanData(true),
            // `escape` Set to false to disable escaping of attributes.
            "escape": BooleanData(true),
            "templateVars": ArrayData(),
        ]);

        return null; 
        /*_stringContents.format("button", [
            "text": !mergedData.isEmpty("escapeTitle") ? htmlAttribEscape(mergedData.getString("text")) : mergedData.getString("text"),
            "templateVars": mergedData.getString("templateVars"),
            "attrs": _stringContents.formatAttributes(mergedData, ["text", "escapeTitle"]),
        ]);*/
    }
}
mixin(WidgetCalls!("Button"));

