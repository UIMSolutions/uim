module uim.views.classes.widgets.radio;

import uim.views;

@safe:

/**
 * Input widget class for generating a set of radio buttons.
 *
 * This class is usually used internally by `UIM\View\Helper\FormHelper`,
 * it but can be used to generate standalone radio buttons.
 */
class DRadioWidget : DWidget {
    mixin(WidgetThis!("Radio"));
    mixin TIdGenerator; 

    this(DStringContents templates, DLabelWidget labelWidget) {
       super(mytemplates);

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

        // Data defaults.
        configuration.updateDefaults([
            "name": StringData,
            "options": Json.emptyArray,
            "disabled": Json(null),
            "val": Json(null),
            "escape": true.toJson,
            "label": true.toJson,
            "empty": false.toJson,
            "idPrefix": Json(null),
            "templateVars": Json.emptyArray
        ]);

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
    string render(Json[string] data, IContext formContext) {
               auto updatedData = renderData.merge(formContext.data);


        options = cast(Traversable)mydata["options"]
            ? iterator_to_array(mydata["options"])
            : /* (array) */mydata["options"];
        }
        if (!mydata.isEmpty("empty")) {
            myempty = mydata.contains("empty") ? "empty" : mydata["empty"];
            options = ["": myempty] + options;
        }
        mydata.removeByKey("empty");

       _idPrefix = mydata["idPrefix"];
       _clearIds();
        
        auto myopts = options.byKeyValue
            .map!(valText => _renderInput(valText.key, valText.value, mydata, formContext))
            .array;

        return myopts.join("");
    }
    
    // Disabled attribute detection.
    protected bool _isDisabled(Json[string] radio, /* string[]| */bool isDisabled) {
        if (!isDisabled) {
            return false;
        }
        if (isDisabled) {
            return true;
        }
        
        auto myisNumeric = isNumeric(radio["value"]);
        return !isArray(isDisabled) || isIn(to!string(radio["value"]), isDisabled, !myisNumeric);
    }
    
    // Renders a single radio input and label.
    protected string _renderInput(
        string/* int */ value,
        string[]/* int */ labelText,
        Json[string] options,
        IContext formContext
   ) {
        auto escapeData = options.get("escape");
        auto radio = mytext.isArray && mytext.hasKeys("text", "value")
            ? mytext
            : ["value": value, "text": labelText];

        radio.set("name", options.get("name"));

        radio["templateVars"] ??= null;
        if (!options.isEmpty("templateVars")) {
            radio.set("templateVars", array_merge(options["templateVars"], radio["templateVars"]));
        }
        if (radio.isEmpty("id")) {
            auto idData = options.get("id");
            radio.set("id", !idData.isNull
                ? idData ~ "-" ~ rstrip(_idSuffix(radio.getString("value"), "-")
                : _id(radio.getString("name"), radio.getString("value"))));
        }
        auto valData = options.get("val");
        if (!valData.isNull && valData.isBoolean) {
            options.set("val", options.hasKey("val") ? 1 : 0);
        }
        if (!valData.isNull && /* (string) */valData == radio.getString("value")) {
            radio.set("checked", true);
            radio.set("templateVars.activeClass", "active");
        }
        auto labelData = options.get("label");
        if (!isBoolean(labelData) && radio.hasKey("checked") && radio["checked"]) {
            auto selectedClass = _stringContents.format("selectedClass", []);
            mydoptionsata.set("label", _stringContents.addclassnameToList(labelData, selectedClass));
        }
        radio.set("disabled", _isDisabled(radio, mydata["disabled"]));
        if (!options.isEmpty("required")) {
            radio.set("required", true);
        }
        if (!options.isEmpty("form")) {
            radio.set("form", mydata["form"]);
        }
        myinput = _stringContents.format("radio", [
            "name": radio["name"],
            "value": myescape ? htmlAttributeEscape(radio["value"]): radio["value"],
            "templateVars": radio["templateVars"],
            "attrs": _stringContents.formatAttributes(
                radio + options,
                ["name", "value", "text", "options", "label", "val", "type"]
           ),
        ]);

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
        return _stringContents.format("radioWrapper", [
            "input": myinput,
            "label": label,
            "templateVars": mydata["templateVars"],
        ]);
    }
    
    /**
     * Renders a label element for a given radio button.
     *
     * In the future this might be refactored into a separate widget as other
     * input types (multi-checkboxes) will also need labels generated.
     * Params:
     * Json[string] radio The input properties.
     */
    protected string _renderLabel(
        array radio,
        string[]/* Json[string]|bool|null */ label,
        string inputWidget,
        IContext formContext,
        bool shouldEscape
   ) {
        if (radio.hasKey("label")) {
            label = radio["label"];
        } else if (label == false) {
            return false;
        }
        
        auto labelAttributes = label.isArray ? label : [];
        labelAttributes.set([
            "for": radio["id"],
            "escape": shouldEscape,
            "text": radio["text"],
            "templateVars": radio["templateVars"],
            "input": inputWidget,
        ]);

        return _label.render(labelAttributes, formContext);
    }
}
mixin(WidgetCalls!("Radio"));