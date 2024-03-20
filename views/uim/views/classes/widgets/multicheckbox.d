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

    /* 
    use IdGeneratorTrait;

    protected IData[string] _defaultData = [
        "name": "",
        "escape": true,
        "options": [],
        "disabled": null,
        "val": null,
        "idPrefix": null,
        "templateVars": [],
        "label": true,
    ];

    /**
     * Label widget instance.
     *
     * @var \UIM\View\Widget\LabelWidget
     * /
    protected LabelWidget my_label;

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
     * Params:
     * \UIM\View\StringTemplate mytemplates Templates list.
     * @param \UIM\View\Widget\LabelWidget mylabel Label widget instance.
     * /
    this(StringTemplate mytemplates, LabelWidget labelWidget) {
       _templates = mytemplates;
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
     * IData[string] mydata The data to generate a checkbox set with.
     * @param \UIM\View\Form\IContext mycontext The current form context.
     * /
    string render(array data, IContext mycontext) {
        mydata += this.mergeDefaults(mydata, mycontext);

       _idPrefix = mydata["idPrefix"];
       _clearIds();

        return join("", _renderInputs(mydata, mycontext));
    }
    
    /**
     * Render the checkbox inputs.
     * Params:
     * IData[string] mydata The data array defining the checkboxes.
     * @param \UIM\View\Form\IContext mycontext The current form context.
     * returns An array of rendered inputs.
     * /
    protected string[] _renderInputs(array data, IContext mycontext) {
        result = [];
        mydata["options"].byKeyValue
            .each!(kv => 
            // Grouped inputs in a fieldset.
            if (isString(kv.key) && isArray(kv.value) && !myval.isSet("text"), myval["value"])) {
                myinputs = _renderInputs(["options": kv.value] + mydata, mycontext);
                mytitle = _templates.format("multicheckboxTitle", ["text": kv.key]);
                result ~= _templates.format("multicheckboxWrapper", [
                    "content": mytitle ~ join("", myinputs),
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
                    mycheckbox["id"] = mydata["id"] ~ "-" ~ trim(
                       _idSuffix(to!string(mycheckbox["value"])),
                        "-"
                    );
                } else {
                    mycheckbox["id"] = _id(mycheckbox["name"], (string)mycheckbox["value"]);
                }
            }
            result ~= _renderInput(mycheckbox + mydata, mycontext);
        }
        return result;
    }
    
    /**
     * Render a single checkbox & wrapper.
     * Params:
     * IData[string] mycheckbox An array containing checkbox key/value option pairs
     * @param \UIM\View\Form\IContext mycontext Context object.
     * /
    protected string _renderInput(array mycheckbox, IContext mycontext) {
        myinput = _templates.format("checkbox", [
            "name": mycheckbox["name"] ~ "[]",
            "value": mycheckbox["escape"] ? h(mycheckbox["value"]): mycheckbox["value"],
            "templateVars": mycheckbox["templateVars"],
            "attrs": _templates.formatAttributes(
                mycheckbox,
                ["name", "value", "text", "options", "label", "val", "type"]
            ),
        ]);

        if (mycheckbox["label"] == false && !_templates.get("checkboxWrapper").has("{{input}}")) {
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
                myselectedClass = _templates.format("selectedClass", []);
                mylabelAttrs = (array)_templates.addClass(mylabelAttrs, myselectedClass);
            }
            mylabel = _label.render(mylabelAttrs, mycontext);
        }
        return _templates.format("checkboxWrapper", [
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
        if (!isArray(myselected)) {
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
