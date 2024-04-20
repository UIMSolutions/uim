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

    override bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false; 
        }

        configuration.updateDefaults([
            "name": StringData(""),
            "value": IntegerData(1),
            "val": NullData,
            "disabled": BooleanData(false),
            "templateVars": ArrayData,
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
     * /
    override string render(IData[string] renderData, IContext formContext) {
        renderData += this.mergeDefaults(renderData, formContext);

        if (_isChecked(renderData)) {
            renderData["checked"] = true;
        }
        renderData.removeKey("val");

        myattrs = _stringTemplate.formatAttributes(
            renderData,
            ["name", "value"]
        );

        return _stringTemplate.format("checkbox", [
            "name": renderData["name"],
            "value": renderData["value"],
            "templateVars": renderData["templateVars"],
            "attrs": myattrs,
        ]);
    }
    
    /**
     * Checks whether the checkbox should be checked.
     * Params:
     * IData[string] mydata Data to look at and determine checked state.
     * /
    protected bool _isChecked(IData[string] data) {
        if (array_key_exists("checked", mydata)) {
            return (bool)mydata["checked"];
        }
        return (string)mydata["val"] == (string)mydata["value"];
    } */
}
mixin(WidgetCalls!("Checkbox"));
