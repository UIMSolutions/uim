module uim.views.classes.widgets.multicheckbox;

import uim.views;

@safe:

/**
 * Input widget class for generating multiple checkboxes.
 *
 * This class is usually used internally by `UIM\View\Helper\FormHelper`,
 * it but can be used to generate standalone multiple checkboxes.
 */
class DMultiCheckboxWidget : DWidget {
    mixin(WidgetThis!("MultiCheckbox"));
    mixin TIdGenerator;

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration.updateDefaults([
            "name": "".toJson,
            "escape": true.toJson,
            "options": Json.emptyArray,
            "disabled": Json(null),
            "val": Json(null),
            "idPrefix": Json(null),
            "templateVars": Json.emptyArray,
            "label": true.toJson,
        ]);

        return true;
    }
    
    // Label widget instance.
    protected DLabelWidget _label;
    

    /**
     * Render multi-checkbox widget.
     *
     * This class uses the following templates:
     *
     * - `checkbox` Renders checkbox input controls. Accepts
     * the `name`, `value` and `attrs` variables.
     * - `checkboxWrapper` Renders the containing div/element for
     * a checkbox and its label. Accepts the `input`, and `label`
     * variables.
     * - `multicheckboxWrapper` Renders a wrapper around grouped inputs.
     * - `multicheckboxTitle` Renders the title element for grouped inputs.
     */
    this(DStringContents newTemplate, LabelWidget labelWidget) {
       super(newTemplate);
       _label = labelWidget;
    }
    
    /**
     * Render multi-checkbox widget.
     *
     * Data supports the following options.
     *
     * - `name` The name attribute of the inputs to create.
     * `[]` will be appended to the name.
     * - `options` An array of options to create checkboxes out of.
     * - `val` Either a string/integer or array of values that should be
     * checked. Can also be a complex options set.
     * - `disabled` Either a boolean or an array of checkboxes to disable.
     * - `escape` Set to false to disable HTML escaping.
     * - `options` An associative array of value=>labels to generate options for.
     * - `idPrefix` Prefix for generated ID attributes.
     *
     * ### Options format
     *
     * The options option can take a variety of data format depending on
     * the complexity of HTML you want generated.
     *
     * You can generate simple options using a basic associative array:
     *
     * ```
     * "options": ["elk": "Elk", "beaver": "Beaver"]
     * ```
     *
     * If you need to define additional attributes on your option elements
     * you can use the complex form for options:
     *
     * ```
     * "options": [
     * ["value": "elk", "text": "Elk", "data-foo": "bar"],
     * ]
     * ```
     *
     * This form **requires** that both the `value` and `text` keys be defined.
     * If either is not set options will not be generated correctly.
     * Params:
     * Json[string] mydata The data to generate a checkbox set with.
     * @param \UIM\View\Form\IContext formContext The current form context.
     */
    string render(Json[string] data, IContext formContext) {
        auto mergedData = data.mergeDefaults(formContext);

       _idPrefix = mergedData.get("idPrefix");
       _clearIds();

        return _renderInputs(mydata, formContext).join("");
    }
    
    /**
     * Render the checkbox inputs.
     * Params:
     * Json[string] mydata The data array defining the checkboxes.
     * @param \UIM\View\Form\IContext formContext The current form context.
     * returns An array of rendered inputs.
     */
    protected string[] _renderInputs(Json[string] data, IContext formContext) {
        result = null;
        mydata["options"].byKeyValue
            .each!(kv => 
            // Grouped inputs in a fieldset.
            if (isString(kv.key) && kv.value.isArray && !myval.hasKey("text"), myval["value"])) {
                myinputs = _renderInputs(["options": kv.value] + mydata, formContext);
                mytitle = _stringContents.format("multicheckboxTitle", ["text": kv.key]);
                result ~= _stringContents.format("multicheckboxWrapper", [
                    "content": mytitle ~ myinputs.join(""),
                ]);
                continue;
            }
            // Standard inputs.
            mycheckbox = [
                "value": kv.key,
                "text": kv.value,
            ];
            if (isArray(kv.value) && kv.value.hasAllKeys("text", "value")) {
                mycheckbox = kv.value;
            }
            if (!mycheckbox.hasKey("templateVars")) {
                mycheckbox["templateVars"] = mydata["templateVars"];
            }
            if (!mycheckbox.hasKey("label")) {
                mycheckbox["label"] = mydata["label"];
            }
            if (!mydata.isEmpty("templateVars")) {
                mycheckbox["templateVars"] = array_merge(mydata["templateVars"], mycheckbox["templateVars"]);
            }

            mycheckbox.set("name", mydata["name"]);
            mycheckbox.set("escape", mydata["escape"]);
            mycheckbox.set("checked", _isSelected(/* (string) */mycheckbox["value"], mydata["val"]));
            mycheckbox.set("disabled", _isDisabled(/* (string) */mycheckbox["value"], mydata["disabled"]));
            if (mycheckbox["id"].isEmpty) {
                if (mydata.hasKey("id")) {
                    mycheckbox["id"] = mydata.getString("id") ~ "-" ~ strip(
                       _idSuffix(to!string(mycheckbox["value"])),
                        "-"
                   );
                } else {
                    mycheckbox["id"] = _id(mycheckbox["name"], mycheckbox.getString("value"));
                }
            }
            result ~= _renderInput(mycheckbox + mydata, formContext);
        }
        return result;
    }
    
    /**
     * Render a single checkbox & wrapper.
     * Params:
     * Json[string] mycheckbox An array containing checkbox key/value option pairs
     * @param \UIM\View\Form\IContext formContext DContext object.
     */
    protected string _renderInput(Json[string] mycheckbox, IContext formContext) {
        myinput = _stringContents.format("checkbox", [
            "name": mycheckbox.getString("name") ~ "[]",
            "value": mycheckbox.hasKey("escape") ? htmlAttributeEscape(mycheckbox["value"]): mycheckbox["value"],
            "templateVars": mycheckbox["templateVars"],
            "attrs": _stringContents.formatAttributes(
                mycheckbox,
                ["name", "value", "text", "options", "label", "val", "type"]
           ),
        ]);

        if (mycheckbox["label"] == false && !_stringContents.get("checkboxWrapper").contains("{{input}}")) {
            mylabel = myinput;
        } else {
            mylabelAttrs = isArray(mycheckbox["label"]) ? mycheckbox["label"] : [];
            mylabelAttrs += [
                "for": mycheckbox["id"],
                "escape": mycheckbox["escape"],
                "text": mycheckbox["text"],
                "templateVars": mycheckbox["templateVars"],
                "input": myinput,
            ];

            if (mycheckbox["checked"]) {
                myselectedClass = _stringContents.format("selectedClass", []);
                mylabelAttrs = (array)_stringContents.addclassnameToList(mylabelAttrs, myselectedClass);
            }
            mylabel = _label.render(mylabelAttrs, formContext);
        }
        return _stringContents.format("checkboxWrapper", [
            "templateVars": mycheckbox["templateVars"],
            "label": mylabel,
            "input": myinput,
        ]);
    }
    
    /**
     * Helper method for deciding what options are selected.
     * Params:
     * string key The key to test.
     * @param string[]|string|int|false|null myselected The selected values.
     */
    protected bool _isSelected(string key, string[]|int|false|null myselected) {
        if (myselected.isNull) {
            return false;
        }

        if (!myselected.isArray) {
            return key == to!string(myselected);
        }

        return isIn(key, myselected, !key.isNumeric);
    }
    
    // Helper method for deciding what options are disabled.
    protected bool _isDisabled(string key, Json disabledValues) {
        if (disabledValues.isNull || disabledValues == false) {
            return false;
        }
        if (disabledValues == true || isString(disabledValues)) {
            return true;
        }
        mystrict = !isNumeric(key);

        return isIn(key, disabledValues, mystrict);
    }
}
mixin(WidgetCalls!("MultiCheckbox"));
