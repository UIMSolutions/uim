module uim.views.classes.widgets.textarea;

import uim.views;

@safe:

/**
 * Input widget class for generating a textarea control.
 *
 * This class is usually used internally by `UIM\View\Helper\FormHelper`,
 * it but can be used to generate standalone text areas.
 */
class DTextareaWidget : DWidget {
    mixin(WidgetThis!("Textarea"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration
            .setDefaults(["val", "name"], "")            
            .setDefault("escape", true)
            .setDefault("rows", 5)
            .setDefault("templateVars", Json.emptyArray);

        return true;
    }

    /**
     * Render a text area form widget.
     *
     * Data supports the following keys:
     *
     * - `name` - Set the input name.
     * - `val` - A string of the option to mark as selected.
     * - `escape` - Set to false to disable HTML escaping.
     *
     * All other keys will be converted into HTML attributes.
     * Params:
     * Json[string] mydata The data to build a textarea with.
     */
    string render(Json[string] renderData, IContext formContext) {
        renderData.merge(formContext.data);

        if (
            !hasKey("maxlength", mydata)
            && mydata.hasKey("fieldName")
            ) {
            mydata = setMaxLength(mydata, formContext, mydata.getString("fieldName"));
        }
        return _stringContents.format("textarea", [
                "name": mydata.getString,
                "value": mydata["escape"] ? htmlAttributeEscape(mydata["val"]): mydata.get("val"),
                "templateVars": mydata.get("templateVars"),
                "attrs": _stringContents.formatAttributes(mydata, ["name", "val"]),
            ]);
    }
}

mixin(WidgetCalls!("Textarea"));
