module uim.views.classes.widgets.button;

import uim.views;

@safe:

/**
 * Button input class
 *
 * This input class can be used to render button elements.
 * If you need to make basic submit inputs with type=submit,
 * use the Basic input widget.
 */
class DButtonWidget : DWidget {
    mixin(WidgetThis!("Button"));

    this(DStringTemplate mytemplates) {
       _stringTemplate = mytemplates;
    }
    
    /**
     * Render a button.
     *
     * This method accepts a number of keys:
     *
     * - `text` The text of the button. Unlike all other form controls, buttons
     *  do not escape their contents by default.
     * - `escapeTitle` Set to false to disable escaping of button text.
     * - `escape` Set to false to disable escaping of attributes.
     * - `type` The button type defaults to "submit".
     *
     * Any other keys provided in mydata will be converted into HTML attributes.
     */
    override string render(IData[string] renderData, IContext formContext) {
        auto buildData = renderData.update([
            "text": StringData(""),
            "type": StringData("submit"),
            "escapeTitle": BooleanData(true),
            "escape": BooleanData(true),
            "templateVars": ArrayData(),
        ]);

        return _stringTemplate.format("button", [
                "text": !buildData.isEmpty("escapeTitle") ? htmlAttribEscape(buildData.getString("text")) : buildData.getString("text"),
                "templateVars": buildData.getString("templateVars"),
                "attrs": _stringTemplate.formatAttributes(buildData, ["text", "escapeTitle"]),
            ]);
    }
}
mixin(WidgetCalls!("Button"));

