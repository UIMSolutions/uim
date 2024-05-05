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

    configuration.updateDefaults([
        "val": Json(""),
        "name": Json(""),
        "escape": Json(true),
        "rows": IntegerData(5),
        "templateVars": Json.emptyArray,
    ]);
    
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
     * @param \UIM\View\Form\IContext formContext The current form context.
     * /
    string render(Json[string] renderData, IContext formContext) {
                        auto mergedData = renderData.merge(formContext.data);


        if (
            !array_key_exists("maxlength", mydata)
            && isSet(mydata["fieldName"])
        ) {
            mydata = this.setMaxLength(mydata, formContext, mydata["fieldName"]);
        }
        return _stringContents.format("textarea", [
            "name": mydata["name"],
            "value": mydata["escape"] ? htmlAttribEscape(mydata["val"]): mydata["val"],
            "templateVars": mydata["templateVars"],
            "attrs": _stringContents.formatAttributes(
                mydata,
                ["name", "val"]
            ),
        ]);
    } */
}
mixin(WidgetCalls!("Textarea"));
