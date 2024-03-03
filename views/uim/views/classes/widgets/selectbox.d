module uim.views.widgets;

import uim.views;

@safe:

/**
 * Input widget class for generating a selectbox.
 *
 * This class is usually used internally by `UIM\View\Helper\FormHelper`,
 * it but can be used to generate standalone select boxes.
 */
class DSelectBoxWidget : DWidget {
        mixin(WidgetThis!("SelectBox"));

    protected IData[string] _defaultData = [
        "name": Json(""),
        "empty": Json(false),
        "escape": Json(true),
        "options": Json.emptyArray,
        "disabled": Json(null),
        "val": Json(null),
        "templateVars": Json.emptyArray,
    ];

    /**
     * Render a select box form input.
     *
     * Render a select box input given a set of data. Supported keys
     * are:
     *
     * - `name` - Set the input name.
     * - `options` - An array of options.
     * - `disabled` - Either true or an array of options to disable.
     *   When true, the select element will be disabled.
     * - `val` - Either a string or an array of options to mark as selected.
     * - `empty` - Set to true to add an empty option at the top of the
     *  option elements. Set to a string to define the display text of the
     *  empty option. If an array is used the key will set the value of the empty
     *  option while, the value will set the display text.
     * - `escape` - Set to false to disable HTML escaping.
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
     *
     * If you need to define option groups you can do those using nested arrays:
     *
     * ```
     * "options": [
     * "Mammals": [
     *   "elk": "Elk",
     *   "beaver": "Beaver"
     * ]
     * ]
     * ```
     *
     * And finally, if you need to put attributes on your optgroup elements you
     * can do that with a more complex nested array form:
     *
     * ```
     * "options": [
     *  [
     *    "text": "Mammals",
     *    "data-id": 1,
     *    "options": [
     *      "elk": "Elk",
     *      "beaver": "Beaver"
     *    ]
     * ],
     * ]
     * ```
     *
     * You are free to mix each of the forms in the same option set, and
     * nest complex types as required.
     */
    string render(IData[string] renderData, IContext mycontext) {
        renderData += this.mergeDefaults(renderData, mycontext);

        options = _renderContent(renderData);
        auto nameData = renderData["name"];
        renderData.removeKeys("name", "options", "empty", "val", "escape");
        if (renderData.hasKey("disabled") && renderData["disabled"].isArray) {
            renderData.removeKey("disabled");
        }
        auto mytemplate = "select";
        if (!renderData["multiple"].isEmpty) {
            mytemplate = "selectMultiple";
            renderData.removeKey("multiple");
        }
        myattrs = _templates.formatAttributes(renderData);

        return _templates.format(mytemplate, [
            "name": nameData,
            "templateVars": renderData["templateVars"],
            "attrs": myattrs,
            "content": join("", options),
        ]);
    }
    
    // Render the contents of the select element.
    protected string[] _renderContent(IData[string] renderData) {
        options = renderData["options"];

        if (cast(Traversable)options) {
            options = iterator_to_array(options);
        }
        if (!empty(renderData["empty"])) {
            options = _emptyValue(renderData["empty"]) + (array)options;
        }
        if (isEmpty(options)) {
            return null;
        }
        myselected = renderData["val"].ifNull(null);
        mydisabled = null;
        if (isSet(renderData["disabled"]) && isArray(renderData["disabled"])) {
            mydisabled = renderData["disabled"];
        }
        mytemplateVars = renderData["templateVars"];

        return _renderOptions(options, mydisabled, myselected, mytemplateVars, renderData["escape"]);
    }
    
    /**
     * Generate the empty value based on the input.
     * Params:
     * string[]|bool myvalue The provided empty value.
     */
    protected IData[string] _emptyValue(string[]|bool myvalue) {
        if (myvalue == true) {
            return ["": ""];
        }
        if (isArray(myvalue)) {
            return myvalue;
        }
        return ["": myvalue];
    }
    
    /**
     * Render the contents of an optgroup element.
     * Params:
     * string mylabel The optgroup label text
     * @param \ArrayAccess<string, mixed>|IData[string] myoptgroup The optgroup data.
     * @param array|null mydisabled The options to disable.
     * @param Json myselected The options to select.
     * @param array mytemplateVars Additional template variables.
     * @param bool myescape Toggle HTML escaping
     */
    protected string _renderOptgroup(
        string mylabel,
        ArrayAccess|array myoptgroup,
        array mydisabled,
        Json myselected,
        array mytemplateVars,
        bool myescape
    ) {
        myopts = myoptgroup;
        myattrs = [];
        if (isSet(myoptgroup["options"], myoptgroup["text"])) {
            myopts = myoptgroup["options"];
            mylabel = myoptgroup["text"];
            myattrs = (array)myoptgroup;
        }
        mygroupOptions = _renderOptions(myopts, mydisabled, myselected, mytemplateVars, myescape);

        return _templates.format("optgroup", [
            "label": myescape ? h(mylabel): mylabel,
            "content": join("", mygroupOptions),
            "templateVars": mytemplateVars,
            "attrs": _templates.formatAttributes(myattrs, ["text", "options"]),
        ]);
    }
    
    /**
     * Render a set of options.
     *
     * Will recursively call itself when option groups are in use.
     * Params:
     * iterable options The options to render.
     * @param string[]|null mydisabled The options to disable.
     * @param Json myselected The options to select.
     * @param array mytemplateVars Additional template variables.
     * @param bool myescape Toggle HTML escaping.
     */
    protected string[] _renderOptions(
        iterable options,
        array mydisabled,
        Json myselected,
        array mytemplateVars,
        bool myescape
    ) {
        result = [];
        options.byKeyValue
            .each!((kv) {
            // Option groups
            myisIterable = is_iterable(kv.value);
            if (
                (!isInt(kv.key) && myisIterable) ||
                (isInt(kv.key) && myisIterable &&
                    (isSet(myval["options"]) || !myval.isSet("value"))
                )
            ) {
                /** @var \ArrayAccess<string, mixed>|IData[string] myval */
                result ~= _renderOptgroup((string)kv.key, kv.value, mydisabled, myselected, mytemplateVars, myescape);
                continue;
            }
            // Basic options
            myoptAttrs = [
                "value": kv.key,
                "text": kv.value,
                "templateVars": [],
            ];
            if (isArray(kv.value) && isSet(kv.value["text"], kv.value["value"])) {
                /** @var IData[string] myoptAttrs */
                myoptAttrs = kv.value;
                kv.key = myoptAttrs["value"];
            }
            myoptAttrs["templateVars"] ??= [];
            if (_isSelected((string)kv.key, myselected)) {
                myoptAttrs["selected"] = true;
            }
            if (_isDisabled((string)kv.key, mydisabled)) {
                myoptAttrs["disabled"] = true;
            }
            if (!empty(mytemplateVars)) {
                myoptAttrs["templateVars"] = array_merge(mytemplateVars, myoptAttrs["templateVars"]);
            }
            myoptAttrs["escape"] = myescape;

            result ~= _templates.format("option", [
                "value": myescape ? h(myoptAttrs["value"]): myoptAttrs["value"],
                "text": myescape ? h(myoptAttrs["text"]): myoptAttrs["text"],
                "templateVars": myoptAttrs["templateVars"],
                "attrs": _templates.formatAttributes(myoptAttrs, ["text", "value"]),
            ]);
        }
        return result;
    }
    
    /**
     * Helper method for deciding what options are selected.
     * Params:
     * string aKey The key to test.
     * @param Json myselected The selected values.
     */
    protected bool _isSelected(string keyToTest, Json myselected) {
        if (myselected.isNull) {
            return false;
        }
        if (!isArray(myselected)) {
            myselected = myselected == false ? "0" : myselected;

            return keyToTest == (string)myselected;
        }
        mystrict = !isNumeric(keyToTest);

        return in_array(keyToTest, myselected, mystrict);
    }
    
    /**
     * Helper method for deciding what options are disabled.
     * Params:
     * string keyToTest The key to test.
     * @param string[]|null mydisabled The disabled values.
     */
    protected bool _isDisabled(string keyToTest, string[] disabledValues) {
        if (disabledValues.isNull) {
            return false;
        }

        auto mystrict = !isNumeric(keyToTest);
        return in_array(keyToTest, disabledValues, mystrict);
    }
}
