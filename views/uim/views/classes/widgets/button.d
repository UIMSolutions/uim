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

    this(DStringTemplate mytemplates) {
       _stringTemplate = mytemplates;
    }

    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false; 
        }

        return true;
    }    
    
    /**
     * Render a button.
     *
     * This method accepts a number of keys:
     *
     *
     * Any other keys provided in mydata will be converted into HTML attributes.
     */
    override string render(IData[string] renderData, IContext formContext) {
        IData[string] buildData = renderData.merge([
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
        // TODO _stringTemplate.format("button", [
                // TODO "text": !buildData.isEmpty("escapeTitle") ? htmlAttribEscape(buildData.getString("text")) : buildData.getString("text"),
        // TODO         "templateVars": buildData.getString("templateVars"),
        // TODO         "attrs": _stringTemplate.formatAttributes(buildData, ["text", "escapeTitle"]),
        // TODO     ]);
    }
}
mixin(WidgetCalls!("Button"));

