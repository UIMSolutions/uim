module uim.views.classes.widgets.checkbox;

import uim.views;

@safe:

/**
 * Input widget for creating checkbox widgets.
 *
 * This class is usually used internally by `UIM\View\Helper\FormHelper`,
 * it but can be used to generate standalone checkboxes.
 */
class DCheckboxWidget : DWidget {
    mixin(WidgetThis!("Checkbox"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false; 
        }

        configuration.updateDefaults([
            "name": Json(""),
            "value": IntegerData(1),
            "val": Json(null),
            "disabled": Json(false),
            "templateVars": Json.emptyArray,
        ]);

        return true;
    }    

    /**
     * Render a checkbox element.
     *
     * Data supports the following keys:
     *
     * - `name` - The name of the input.
     * - `value` - The value attribute. Defaults to "1".
     * - `val` - The current value. If it matches `value` the checkbox will be checked.
     *  You can also use the "checked" attribute to make the checkbox checked.
     * - `disabled` - Whether the checkbox should be disabled.
     *
     * Any other attributes passed in will be treated as HTML attributes.
     */
    override string render(Json[string] renderData, IContext formContext) {
        auto mergedData = renderData.merge(formContext.data);

        /* 
        if (_isChecked(renderData)) {
            mergedData["checked"] = true;
        }
        mergedData.removeKey("val");

        auto myattrs = _stringContents.formatAttributes(
            mergedData,
            ["name", "value"]
        );

        return _stringContents.format("checkbox", [
            "name": mergedData["name"],
            "value": mergedData["value"],
            "templateVars": mergedData["templateVars"],
            "attrs": myattrs,
        ]);
        */
        return null;
    }
    
    /**
     * Checks whether the checkbox should be checked.
     * Params:
     * Json[string] mydata Data to look at and determine checked state.
     * /
    protected bool _isChecked(Json[string] data) {
        if (array_key_exists("checked", mydata)) {
            return (bool)mydata["checked"];
        }
        return (string)mydata["val"] == (string)mydata["value"];
    } */
}
mixin(WidgetCalls!("Checkbox"));
