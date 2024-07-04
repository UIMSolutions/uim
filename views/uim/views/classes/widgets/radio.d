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


        if (cast(Traversable)mydata["options"]) {
            options = iterator_to_array(mydata["options"]);
        } else {
            options = (array)mydata["options"];
        }
        if (!mydata["empty"].isEmpty) {
            myempty = mydata.contains("empty") ? "empty" : mydata["empty"];
            options = ["": myempty] + options;
        }
        mydata.remove("empty");

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
        return !isArray(isDisabled) || isIn(to!string(myradio["value"]), isDisabled, !myisNumeric);
    }
    
    /**
     * Renders a single radio input and label.
     * Params:
     * string|int myval The value of the radio input.
     * @param Json[string]|string|int mytext The label text, or complex radio type.
     * @param Json[string] mydata Additional options for input generation.
     */
    protected string _renderInput(
        string|int myval,
        string[]|int mytext,
        Json[string] options,
        IContext formContext
   ) {
        auto escapeData = options.get("escape"];
        auto myRadio = mytext.isArray && mytext.hasKeys("text", "value")
            ? mytext
            : ["value": myval, "text": mytext];

        myradio["name"] = options.get("name"];

        myradio["templateVars"] ??= null;
        if (!options.isEmpty("templateVars"])) {
            myradio["templateVars"] = array_merge(options["templateVars"], myradio["templateVars"]);
        }
        if (myradio.isEmpty("id")) {
            auto idData = options.get("id"];
            myradio["id"] = !idData.isNull
                ? idData ~ "-" ~ rstrip(_idSuffix(/* (string) */myradio["value"]), "-")
                : _id(to!string(myradio["name"]), (string)myradio["value"]);
        }
        auto valData = options.get("val"];
        if (!valData.isNull && valData.isBoolean) {
            options["val"] = options.get("val"] ? 1 : 0;
        }
        if (!valData.isNull && /* (string) */valData == /* (string) */myradio["value"]) {
            myradio["checked"] = true;
            myradio["templateVars.activeClass"] = "active";
        }
        auto labelData = options.get("label"];
        if (!isBoolean(labelData) && myradio.hasKey("checked") && myradio["checked"]) {
            myselectedClass = _stringContents.format("selectedClass", []);
            mydoptionsata["label"] = _stringContents.addclassnameToList(labelData, myselectedClass);
        }
        myradio["disabled"] = _isDisabled(myradio, mydata["disabled"]);
        if (!options.isEmpty("required"])) {
            myradio["required"] = true;
        }
        if (!options.isEmpty("form"])) {
            myradio["form"] = mydata["form"];
        }
        myinput = _stringContents.format("radio", [
            "name": myradio["name"],
            "value": myescape ? htmlAttributeEscape(myradio["value"]): myradio["value"],
            "templateVars": myradio["templateVars"],
            "attrs": _stringContents.formatAttributes(
                myradio + options,
                ["name", "value", "text", "options", "label", "val", "type"]
           ),
        ]);

        string mylabel = _renderLabel(
            myradio,
            labelData,
            myinput,
            formContext,
            myescape
       );

        if (
            mylabel == false &&
            !_stringContents.get("radioWrapper").contains("{{input}}")
       ) {
            mylabel = myinput;
        }
        return _stringContents.format("radioWrapper", [
            "input": myinput,
            "label": mylabel,
            "templateVars": mydata["templateVars"],
        ]);
    }
    
    /**
     * Renders a label element for a given radio button.
     *
     * In the future this might be refactored into a separate widget as other
     * input types (multi-checkboxes) will also need labels generated.
     * Params:
     * Json[string] myradio The input properties.
     * @param Json[string]|string mylabel The properties for a label.
     * @param string myinput The input widget.
     * @param \UIM\View\Form\IContext formContext The form context.
     * @param bool shouldEscape Whether to HTML escape the label.
     */
    protected string _renderLabel(
        array myradio,
        string[]/* |bool|null */ mylabel,
        string myinput,
        IContext formContext,
        bool shouldEscape
   ) {
        if (myradio.hasKey("label")) {
            mylabel = myradio["label"];
        } elseif (mylabel == false) {
            return false;
        }
        
        auto labelAttributes = mylabel.isArray ? mylabel : [];
        labelAttributes += [
            "for": myradio["id"],
            "escape": shouldEscape,
            "text": myradio["text"],
            "templateVars": myradio["templateVars"],
            "input": myinput,
        ];

        return _label.render(labelAttributes, formContext);
    }
}
mixin(WidgetCalls!("Radio"));