/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.widgets.radio;

import uim.views;

@safe:

unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
}

/**
 * Input widget class for generating a set of radio buttons.
 *
 * This class is usually used internally by `UIM\View\Helper\FormHelper`,
 * it but can be used to generate standalone radio buttons.
 */
class DRadioWidget : DWidget {
    mixin(WidgetThis!("Radio"));
    // mixin TIdGenerator;

    this(DStringContents templates, DLabelWidget labelWidget) {
        // super(mytemplates);

        /* - `radio` Used to generate the input for a radio button.
        * Can use the following variables `name`, `value`, `attrs`.
        * - `radioWrapper` Used to generate the container element for
        * the radio + input element. Can use the `input` and `label`
        * variables. */
        _label = labelWidget;
    }

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration
            .setDefault("name", "")
            .setDefaults(["options", "templateVars"], Json.emptyArray)
            .setDefaults(["disabled", "val", "idPrefix"], Json(null))
            .setDefaults(["escape", "label"], true)
            .setDefault("empty", false); 

        return true;
    }

    // Label instance.
    protected DLabelWidget _label;

    /**
     * Render a set of radio buttons.
     *
     * Data supports the following keys:
     *
     * - `name` - Set the input name.
     * - `options` - An array of options. See below for more information.
     * - `disabled` - Either true or an array of inputs to disable.
     *  When true, the select element will be disabled.
     * - `val` - A string of the option to mark as selected.
     * - `label` - Either false to disable label generation, or
     * an array of attributes for all labels.
     * - `required` - Set to true to add the required attribute
     * on all generated radios.
     * - `idPrefix` Prefix for generated ID attributes.
     */
    override string render(Json[string] data, IFormContext formContext) {
/*         data.merge(formContext.data);

        options = data.get("options")
            ? iterator_to_array(data.get("options")) : data.getArray("options");

        if (!data.isEmpty("empty")) {
            auto empty = data.hasKey("empty") ? "empty" : data.getString("empty");
            options = options.set("", empty);
        }

        data.removeKey("empty");

        _idPrefix = data.get("idPrefix");
        _clearIds();

        auto myopts = options.byKeyValue
            .map!(valText => _renderInput(valText.key, valText.value, data, formContext))
            .array;

        return myopts.join(""); 
 */        return null;
    }

    // Disabled attribute detection.
    protected bool _isDisabled(Json[string] radio, /* string[]| */ bool isDisabled) {
        /* if (!isDisabled) {
            return false;
        }
        if (isDisabled) {
            return true;
        }

        auto myisNumeric = isNumeric(radio.get("value"));
        return !isArray(isDisabled) || isIn(to!string(radio.get("value")), isDisabled, !myisNumeric); */
        return false;
    }

    // Renders a single radio input and label.
    protected string _renderInput(
        string /* int */ value,
        string[] /* int */ labelText,
        Json[string] options,
        IFormContext formContext
    ) {
        /* auto escapeData = options.get("escape");
        auto radio = mytext.isArray && mytext.hasKeys("text", "value")
            ? mytext
            : ["value": value, "text": labelText];

        radio.set("name", options.get("name"));

        radio.set("templateVars", radio.get("templateVars"));
        if (options.hasKey("templateVars")) {
            radio.set("templateVars", array_merge(options.get("templateVars"), radio.get(
                    "templateVars")));
        }
        if (radio.isEmpty("id")) {
            auto idData = options.get("id");
            radio.set("id", !idData.isNull
                    ? idData ~ "-" ~ stripRight_idSuffix(radio.getString("value"), "-") : _id(
                        radio.getString("name"), radio.getString("value")));
        }
        auto valData = options.get("val");
        if (options.isBoolean("val")) {
            options.set("val", options.getBoolean("val") ? 1 : 0);
        }
        if (!valData.isNull && valData == radio.getString("value")) {
            radio.set("checked", true);
            radio.set("templateVars.activeClass", "active");
        }
        auto labelData = options.get("label");
        if (!isBoolean(labelData) && radio.hasKey("checked") && radio["checked"]) {
            auto selectedClass = _stringContents.format("selectedClass", []);
            mydoptionsata.set("label", _stringContents.addclassnameToList(labelData, selectedClass));
        }
        radio.set("disabled", _isDisabled(radio, data["disabled"]));
        if (options.hasKey("required")) {
            radio.set("required", true);
        }
        if (options.hasKey("form")) {
            radio.set("form", data["form"]);
        }
        myinput = _stringContents.format("radio", MapHelper.create!(string, Json)
                .merge("name", radio["name"])
                .merge("value", myescape ? htmlAttributeEscape(radio["value"]) : radio["value"])
                .merge("templateVars", radio["templateVars"])
                /* .merge("attrs", _stringContents.formatAttributes(
                    radio + options,
                    ["name", "value", "text", "options", "label", "val", "type"]
                ))] * /);

        string label = _renderLabel(
            radio,
            labelData,
            myinput,
            formContext,
            myescape
        );

        if (
            label == false &&
            !_stringContents.get("radioWrapper").contains("{{input}}")
            ) {
            label = myinput;
        }
        return _stringContents.format("radioWrapper", MapHelper.create!(string, Json)
                .merge("input", myinput)
                .merge("label", label)
                .merge("templateVars", data["templateVars"])); */

        return null;
    }

    /**
     * Renders a label element for a given radio button.
     *
     * In the future this might be refactored into a separate widget as other
     * input types (multi-checkboxes) will also need labels generated.
     */
    protected string _renderLabel(
        Json[string] radio,
        string[] /* Json[string]|bool|null */ label,
        string inputWidget,
        IFormContext formContext,
        bool shouldEscape
    ) {
        /* if (radio.hasKey("label")) {
            label = radio["label"];
        } else if (label == false) {
            return false;
        }

        auto labelAttributes = label.isArray ? label : [];
        labelAttributes
            .set("for", radio["id"])
            .set("escape", shouldEscape)
            .set("text", radio["text"])
            .set("templateVars", radio["templateVars"])
            .set("input", inputWidget);

        return _label.render(labelAttributes, formContext); */
        return null;
    }
}

mixin(WidgetCalls!("Radio"));

unittest {
    assert(RadioWidget);
}
