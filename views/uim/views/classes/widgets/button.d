module uim.views.widgets.button;

import uim.views;

@safe:

/**
 * Button input class
 *
 * This input class can be used to render button elements.
 * If you need to make basic submit inputs with type=submit,
 * use the Basic input widget.
 */
class ButtonWidget : IWidget {
    mixin(WidgetThis!("Button"));

    // StringTemplate instance.
    protected StringTemplate _templates;

    /**
     * Constructor.
     * Params:
     * \UIM\View\StringTemplate mytemplates Templates list.
     */
    this(StringTemplate mytemplates) {
       _templates = mytemplates;
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
    string render(IData[string] renderData, IContext formContext) {
        buildData.update([
            "text": StringData(""),
            "type": StringData("submit"),
            "escapeTitle": BoolData(true),
            "escape": BoolData(true),
            "templateVars": ArrayData(),
        ]);

        return _templates.format("button", [
                "text": buildData["escapeTitle"] ? h(buildData["text"]): buildData["text"],
                "templateVars": buildData["templateVars"],
                "attrs": _templates.formatAttributes(buildData, ["text", "escapeTitle"]),
            ]);
    }
    
    Json[] secureFields(IData[string] mydata) {
        if (!mydata.isSet("name") || mydata["name"].isEmpty) {
            return null;
        }
        return [mydata["name"]];
    }
}
mixin(WidgetCalls!("Button"));

