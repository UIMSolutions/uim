module uim.views.classes.widgets.selectbox;

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

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

    configuration.updateDefaults([
        "name": "".toJson,
        "empty": false.toJson,
        "escape": true.toJson,
        "options": Json.emptyArray,
        "disabled": Json(null),
        "val": Json(null),
        "templateVars": Json.emptyArray,
    ]);

        return true;
    }


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
    string render(Json[string] renderData, IContext formContext) {
                auto mergedData = renderData.merge(formContext.data);


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
        myattrs = _stringContents.formatAttributes(renderData);

        return _stringContents.format(mytemplate, [
            "name": nameData,
            "templateVars": renderData["templateVars"],
            "attrs": myattrs,
            "content": options.join(""),
        ]);
    }
    
    // Render the contents of the select element.
    protected string[] _renderContent(Json[string] renderData) {
        Json options = renderData.get("options", null);

        if (cast(Traversable)options) {
            options = iterator_to_array(options);
        }
        if (!renderData.isEmpty("empty")) {
            options = _emptyValue(renderData["empty"]) + (array)options;
        }
        if (options.isEmpty) {
            return null;
        }
        
        Json myselected = renderData.get("val", null);
        Json mydisabled = null;
        if (renderData.hasKey("disabled") && renderData["disabled"].isArray) {
            mydisabled = renderData.get("disabled", null)];
        }
        mytemplateVars = renderData["templateVars"];

        return _renderOptions(options, mydisabled, myselected, mytemplateVars, renderData["escape"]);
    }
    
    // Generate the empty value based on the input.
    protected Json[string] _emptyValue(bool myvalue) {
        return myvalue 
            ? ["": "".toJson] 
            : ["": Json(myvalue)];
    }

    protected Json[string] _emptyValue(Json[string] values) {
        return myvalue.isEmpty
            ? ["": myvalue]
            : return myvalue;
    }
    
    /**
     * Render the contents of an optgroup element.
     * Params:
     * string mylabel The optgroup label text
     * @param \ArrayAccess<string, mixed>|Json[string] myoptgroup The optgroup data.
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
        Json[string] mytemplateVars,
        bool myescape
    ) {
        myopts = myoptgroup;
        myattrs = null;
        if (isSet(myoptgroup["options"], myoptgroup["text"])) {
            myopts = myoptgroup["options"];
            mylabel = myoptgroup["text"];
            myattrs = (array)myoptgroup;
        }
        mygroupOptions = _renderOptions(myopts, mydisabled, myselected, mytemplateVars, myescape);

        return _stringContents.format("optgroup", [
            "label": myescape ? htmlAttributeEscape(mylabel): mylabel,
            "content": mygroupOptions.join(""),
            "templateVars": mytemplateVars,
            "attrs": _stringContents.formatAttributes(myattrs, ["text", "options"]),
        ]);
    }
    
    /**
     * Render a set of options.
     *
     * Will recursively call itself when option groups are in use.
     * Params:
     * range options The options to render.
     * @param string[] mydisabled The options to disable.
     * @param Json myselected The options to select.
     * @param array mytemplateVars Additional template variables.
     * @param bool myescape Toggle HTML escaping.
     */
    protected string[] _renderOptions(
        range options,
        Json[string] mydisabled,
        Json myselected,
        array mytemplateVars,
        bool myescape
    ) {
        result = null;
        options.byKeyValue
            .each!((kv) {
            // Option groups
            myisRange = is_iterable(kv.value);
            if (
                (!isInt(kv.key) && myisIterable) ||
                (isInt(kv.key) && myisRange &&
                    (isSet(myval["options"]) || !myval.isSet("value"))
                )
            ) {
                /** @var \ArrayAccess<string, mixed>|Json[string] myval */
                result ~= _renderOptgroup((string)kv.key, kv.value, mydisabled, myselected, mytemplateVars, myescape);
                continue;
            }
            // Basic options
            myoptAttrs = [
                "value": kv.key,
                "text": kv.value,
                "templateVars": Json.emptyArray,
            ];
            if (isArray(kv.value) && isSet(kv.value["text"], kv.value["value"])) {
                /** @var Json[string] myoptAttrs */
                myoptAttrs = kv.value;
                kv.key = myoptAttrs["value"];
            }
            myoptAttrs["templateVars"] ??= null;
            if (_isSelected(to!string(kv.key), myselected)) {
                myoptAttrs["selected"] = true;
            }
            if (_isDisabled(to!string(kv.key), mydisabled)) {
                myoptAttrs["disabled"] = true;
            }
            if (!mytemplateVars.isEmpty) {
                myoptAttrs["templateVars"] = array_merge(mytemplateVars, myoptAttrs["templateVars"]);
            }
            myoptAttrs["escape"] = myescape;

            result ~= _stringContents.format("option", [
                "value": myescape ? htmlAttributeEscape(myoptAttrs["value"]): myoptAttrs["value"],
                "text": myescape ? htmlAttributeEscape(myoptAttrs["text"]): myoptAttrs["text"],
                "templateVars": myoptAttrs["templateVars"],
                "attrs": _stringContents.formatAttributes(myoptAttrs, ["text", "value"]),
            ]);
        }
        return result;
    }
    
    /**
     * Helper method for deciding what options are selected.
     * Params:
     * @param Json myselected The selected values.
     */
    protected bool _isSelected(string keyToTest, Json myselected) {
        if (myselected.isNull) {
            return false;
        }
        if (!myselected.isArray) {
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
     * @param string[] mydisabled The disabled values.
     */
    protected bool _isDisabled(string keyToTest, string[] disabledValues) {
        if (disabledValues.isNull) {
            return false;
        }

        auto mystrict = !keyToTest.isNumeric;
        return in_array(keyToTest, disabledValues, mystrict);
    } */
}
