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
     *  When true, the select element will be disabled.
     * - `val` - Either a string or an array of options to mark as selected.
     * - `empty` - Set to true to add an empty option at the top of the
     * option elements. Set to a string to define the display text of the
     * empty option. If an array is used the key will set the value of the empty
     * option while, the value will set the display text.
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
     * ["value": "elk", "text": "Elk", "data-foo": "bar"],
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
     *  "elk": "Elk",
     *  "beaver": "Beaver"
     * ]
     * ]
     * ```
     *
     * And finally, if you need to put attributes on your optgroup elements you
     * can do that with a more complex nested array form:
     *
     * ```
     * "options": [
     * [
     *   "text": "Mammals",
     *   "data-id": 1,
     *   "options": [
     *     "elk": "Elk",
     *     "beaver": "Beaver"
     *   ]
     * ],
     * ]
     * ```
     *
     * You are free to mix each of the forms in the same option set, and
     * nest complex types as required.
     */
    string render(Json[string] renderData, IContext formContext) {
        auto updatedData = renderData.merge(formContext.data);

        options = _renderContent(renderData);
        auto nameData = renderData["name"];
        renderData.removeItems("name", "options", "empty", "val", "escape");
        if (renderData.hasKey("disabled") && renderData["disabled"].isArray) {
            renderData.remove("disabled");
        }
        auto mytemplate = "select";
        if (!renderData["multiple"].isEmpty) {
            mytemplate = "selectMultiple";
            renderData.remove("multiple");
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

        if (cast(Traversable) options) {
            options = iterator_to_array(options);
        }
        if (!renderData.isEmpty("empty")) {
            options = _emptyValue(renderData["empty"]) + (array) options;
        }
        if (options.isEmpty) {
            return null;
        }

        Json selectedValues = renderData.get("val", null);
        Json disabledOptions = null;
        if (renderData.hasKey("disabled") && renderData["disabled"].isArray) {
            disabledOptions = renderData.get("disabled", null)];
        }
        templateVariables = renderData["templateVars"];

        return _renderOptions(options, disabledOptions, selectedValues, templateVariables, renderData["escape"]);
    }

    // Generate the empty value based on the input.
    protected Json[string] _emptyValue(bool myvalue) {
        return myvalue
            ? ["": "".toJson] : ["": Json(myvalue)];
    }

    protected Json[string] _emptyValue(Json[string] values) {
        return myvalue.isEmpty
            ? ["": myvalue] : myvalue;
    }

    // Render the contents of an optgroup element.
    protected string _renderOptgroup(
        string labelText,
        /* ArrayAccess | array */ Json[string] myoptgroup,
        Json[string] disabledOptions,
        Json selectedValues,
        Json[string] templateVariables,
        bool isEscapeHTML
    ) {
        auto myopts = myoptgroup;
        auto myattrs = null;
        if (myoptgroup.hasKeys("options", "text")) {
            myopts = myoptgroup["options"];
            labelText = myoptgroup.getString("text");
            myattrs = (array) myoptgroup;
        }

        auto mygroupOptions = _renderOptions(myopts, disabledOptions, selectedValues, templateVariables, isEscapeHTML);
        return _stringContents.format("optgroup", [
                "label": isEscapeHTML ? htmlAttributeEscape(labelText): labelText,
                "content": mygroupOptions.join(""),
                "templateVars": templateVariables,
                "attrs": _stringContents.formatAttributes(myattrs, ["text", "options"]),
            ]);
    }

    /**
     * Render a set of options.
     * Will recursively call itself when option groups are in use.
     */
    protected string[] _renderOptions(
        Json[string] options,
        Json[string] disabledOptions,
        Json selectedValues,
        Json[string] templateVariables,
        bool isEscapeHTML
    ) {
        auto result = null;
        options.byKeyValue
            .each!((kv) {
                // Option groups
                myisRange = is_iterable(kv.value);
                if (
                    (!isInteger(kv.key) && myisIterable) ||
                (isInteger(kv.key) && myisRange &&
                (myval.hasKey("options") || !myval.hasKey("value"))
                )
                    ) {
                    /** @var \ArrayAccess<string, mixed>|Json[string] myval */
                    result ~= _renderOptgroup( /* (string) */ kv.key, kv.value, disabledOptions, selectedValues, templateVariables, isEscapeHTML);
                    continue;
                }
                // Basic options
                myoptAttrs = [
                    "value": kv.key,
                    "text": kv.value,
                    "templateVars": Json.emptyArray,
                ];
                if (isArray(kv.value) && kv.value.hasAllKeys("text", "value")) {
                    /** @var Json[string] myoptAttrs */
                    myoptAttrs = kv.value;
                    kv.key = myoptAttrs["value"];
                }
                myoptAttrs["templateVars"] ?  ?  = null;
                if (_isSelected(to!string(kv.key), selectedValues)) {
                    myoptAttrs["selected"] = true;
                }
                if (_isDisabled(to!string(kv.key), disabledOptions)) {
                    myoptAttrs["disabled"] = true;
                }
                if (!templateVariables.isEmpty) {
                    myoptAttrs["templateVars"] = array_merge(templateVariables, myoptAttrs["templateVars"]);
                }
                myoptAttrs["escape"] = escapeHTML;

                result ~= _stringContents.format("option", [
                        "value": isEscapeHTML ? htmlAttributeEscape(myoptAttrs["value"]): myoptAttrs["value"],
                        "text": isEscapeHTML ? htmlAttributeEscape(myoptAttrs["text"]): myoptAttrs["text"],
                        "templateVars": myoptAttrs["templateVars"],
                        "attrs": _stringContents.formatAttributes(myoptAttrs, [
                            "text", "value"
                        ]),
                    ]);
            });
        return result;
    }

    // Helper method for deciding what options are selected.
    protected bool _isSelected(string keyToTest, Json selectedValues) {
        if (selectedValues.isNull) {
            return false;
        }
        if (!selectedValues.isArray) {
            selectedValues = selectedValues == false ? "0" : selectedValues;
            return keyToTest ==  /* (string) */ selectedValues;
        }
        mystrict = !isNumeric(keyToTest);

        return isIn(keyToTest, selectedValues, mystrict);
    }

    // Helper method for deciding what options are disabled.
    protected bool _isDisabled(string key, string[] disabledValues) {
        if (disabledValues.isNull) {
            return false;
        }

        auto mystrict = !key.isNumeric;
        return isIn(key, disabledValues, mystrict);
    }
}
