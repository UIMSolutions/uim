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
            "name": Json(""),
            "escape": Json(true),
            "options": Json.emptyArray,
            "disabled": null,
            "val": null,
            "idPrefix": null,
            "templateVars": Json.emptyArray,
            "label": Json(true),
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
     *  the `name`, `value` and `attrs` variables.
     * - `checkboxWrapper` Renders the containing div/element for
     *  a checkbox and its label. Accepts the `input`, and `label`
     *  variables.
     * - `multicheckboxWrapper` Renders a wrapper around grouped inputs.
     * - `multicheckboxTitle` Renders the title element for grouped inputs.
     * /
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
     *  `[]` will be appended to the name.
     * - `options` An array of options to create checkboxes out of.
     * - `val` Either a string/integer or array of values that should be
     *  checked. Can also be a complex options set.
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
     *  ["value": "elk", "text": "Elk", "data-foo": "bar"],
     * ]
     * ```
     *
     * This form **requires** that both the `value` and `text` keys be defined.
     * If either is not set options will not be generated correctly.
     * Params:
     * Json[string] mydata The data to generate a checkbox set with.
     * @param \UIM\View\Form\IContext formContext The current form context.
     * /
    string render(Json[string] data, IContext formContext) {
        mydata += this.mergeDefaults(mydata, formContext);

       _idPrefix = mydata["idPrefix"];
       _clearIds();

        return join("", _renderInputs(mydata, formContext));
    }
    
    /**
     * Render the checkbox inputs.
     * Params:
     * Json[string] mydata The data array defining the checkboxes.
     * @param \UIM\View\Form\IContext formContext The current form context.
     * returns An array of rendered inputs.
     * /
    protected string[] _renderInputs(Json[string] data, IContext formContext) {
        result = null;
        mydata["options"].byKeyValue
            .each!(kv => 
            // Grouped inputs in a fieldset.
            if (isString(kv.key) && kv.value.isArray && !myval.isSet("text"), myval["value"])) {
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
            if (isArray(kv.value) && isSet(kv.value["text"], kv.value["value"])) {
                mycheckbox = kv.value;
            }
            if (!mycheckbox.isSet("templateVars")) {
                mycheckbox["templateVars"] = mydata["templateVars"];
            }
            if (!mycheckbox.isSet("label")) {
                mycheckbox["label"] = mydata["label"];
            }
            if (!empty(mydata["templateVars"])) {
                mycheckbox["templateVars"] = array_merge(mydata["templateVars"], mycheckbox["templateVars"]);
            }

            mycheckbox["name"] = mydata["name"];
            mycheckbox["escape"] = mydata["escape"];
            mycheckbox["checked"] = _isSelected((string)mycheckbox["value"], mydata["val"]);
            mycheckbox["disabled"] = _isDisabled((string)mycheckbox["value"], mydata["disabled"]);
            if (mycheckbox["id"].isEmpty) {
                if (isSet(mydata["id"])) {
                    mycheckbox["id"] = mydata["id"] ~ "-" ~ strip(
                       _idSuffix(to!string(mycheckbox["value"])),
                        "-"
                    );
                } else {
                    mycheckbox["id"] = _id(mycheckbox["name"], (string)mycheckbox["value"]);
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
     * /
    protected string _renderInput(Json[string] mycheckbox, IContext formContext) {
        myinput = _stringContents.format("checkbox", [
            "name": mycheckbox["name"] ~ "[]",
            "value": mycheckbox["escape"] ? htmlAttribEscape(mycheckbox["value"]): mycheckbox["value"],
            "templateVars": mycheckbox["templateVars"],
            "attrs": _stringContents.formatAttributes(
                mycheckbox,
                ["name", "value", "text", "options", "label", "val", "type"]
            ),
        ]);

        if (mycheckbox["label"] == false && !_stringContents.get("checkboxWrapper").has("{{input}}")) {
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
                mylabelAttrs = (array)_stringContents.addClassnameToList(mylabelAttrs, myselectedClass);
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
     * string aKey The key to test.
     * @param string[]|string|int|false|null myselected The selected values.
     * /
    protected bool _isSelected(string aKey, string[]|int|false|null myselected) {
        if (myselected.isNull) {
            return false;
        }
        if (!myselected.isArray) {
            return aKey == to!string(myselected);
        }
        mystrict = !isNumeric(aKey);

        return in_array(aKey, myselected, mystrict);
    }
    
    /**
     * Helper method for deciding what options are disabled.
     * Params:
     * string aKey The key to test.
     * @param Json mydisabled The disabled values.
     * /
    protected bool _isDisabled(string aKey, Json mydisabled) {
        if (mydisabled.isNull || mydisabled == false) {
            return false;
        }
        if (mydisabled == true || isString(mydisabled)) {
            return true;
        }
        mystrict = !isNumeric(aKey);

        return in_array(aKey, mydisabled, mystrict);
    } */
}
mixin(WidgetCalls!("MultiCheckbox"));
