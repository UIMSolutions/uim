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

    /* 
    protected IData[string] _defaultData = [
        "val": Json(""),
        "name": Json(""),
        "escape": Json(true),
        "rows": Json(5),
        "templateVars": Json.emptyArray,
    ];

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
     * IData[string] mydata The data to build a textarea with.
     * @param \UIM\View\Form\IContext mycontext The current form context.
     * /
    string render(IData[string] renderData, IContext mycontext) {
        mydata += this.mergeDefaults(mydata, mycontext);

        if (
            !array_key_exists("maxlength", mydata)
            && isSet(mydata["fieldName"])
        ) {
            mydata = this.setMaxLength(mydata, mycontext, mydata["fieldName"]);
        }
        return _stringTemplate.format("textarea", [
            "name": mydata["name"],
            "value": mydata["escape"] ? htmlAttribEscape(mydata["val"]): mydata["val"],
            "templateVars": mydata["templateVars"],
            "attrs": _stringTemplate.formatAttributes(
                mydata,
                ["name", "val"]
            ),
        ]);
    } */
}
mixin(WidgetCalls!("Textarea"));
