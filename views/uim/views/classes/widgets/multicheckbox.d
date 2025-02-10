/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.widgets.multicheckbox;

import uim.views;

@safe:

unittest {
  writeln("-----  ", __MODULE__, "\t  -----");
}

/**
 * Input widget class for generating multiple checkboxes.
 *
 * This class is usually used internally by `UIM\View\Helper\FormHelper`,
 * it but can be used to generate standalone multiple checkboxes.
 */
class DMultiCheckboxWidget : DWidget {
  mixin(WidgetThis!("MultiCheckbox"));
  // mixin TIdGenerator;

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
  this(DStringContents newTemplate, DLabelWidget labelWidget) {
    // super(newTemplate);
    _label = labelWidget;
  }

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    /* configuration
      .setDefaults(["disabled", "val", "idPrefix"], Json(null))
      .setDefault("name", "")
      .setDefaults(["escape", "label"], true)
      .setDefaults(["options", "templateVars"], Json.emptyArray); */

    return true;
  }

  // Label widget instance.
  protected DLabelWidget _label;

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
     */
  override string render(Json[string] data, IFormContext formContext) {
/*     data.merge(formContext);

    _idPrefix = data.get("idPrefix");
    _clearIds();

    return _renderInputs(data, formContext).join(""); */
    return null; 
  }

  // Render the checkbox inputs.
  protected string[] _renderInputs(Json[string] data, IFormContext formContext) {
    string[] result = null;
    /* data.getMap("options").byKeyValue
      .each!((kv) => {
        // Grouped inputs in a fieldset.
        if (kv.value.isArray && !kv.value.hasKey("text") /* , kv.value["value"] * / ) {
          auto myinputs = _renderInputs(["options": kv.value].merge(data), formContext);
          string checkboxTitle = _stringContents.format("multicheckboxTitle", MapHelper.create!(string, Json)
            .set("text", kv.key));
          result ~= _stringContents.format("multicheckboxWrapper", MapHelper.create!(string, Json)
              .set("content", checkboxTitle ~ myinputs.join("")));
          continue;
        }
      }); */

    // Standard inputs.
    /* auto mycheckbox = MapHelper.create!(string, Json)
      .set("value", kv.key)
      .set("text", kv.value);
    if (kv.value.isArray && kv.value.hasAllKeys("text", "value")) {
      mycheckbox = kv.value;
    }
    if (!mycheckbox.hasKey("templateVars")) {
      mycheckbox.set("templateVars", data.get("templateVars"));
    }
    if (!mycheckbox.hasKey("label")) {
      mycheckbox.set("label", data.get("label"));
    }
    if (!mydata.isEmpty("templateVars")) {
      mycheckbox.set("templateVars", array_merge(data.get("templateVars"), mycheckbox
          .get("templateVars")));
    }

    mycheckbox.set(mydata.getKeys("name", "escape"));
    mycheckbox.set("checked", _isSelected(mycheckbox.getString("value"), data
        .get("val")));
    mycheckbox.set("disabled", _isDisabled(
        mycheckbox.getString("value"), data.get("disabled")));
    if (mycheckbox.isEmpty("id")) {
      if (mydata.hasKey("id")) {
        mycheckbox.set("id", mydata.getString("id") ~ "-" ~
            _idSuffix(mycheckbox.getString("value"))
            .strip("-"));
      } else {
        mycheckbox.get("id", _id(mycheckbox.getString("name"), mycheckbox.getString("value")));
      }
    }
    result ~= _renderInput(mycheckbox + mydata, formContext); */
    /*  } */

    return result;
  }

  // Render a single checkbox & wrapper.
  protected string _renderInput(Json[string] checkboxData, IFormContext formContext) {
    /* auto myinput = _stringContents.format("checkbox", [
        "name": checkboxData.getString("name") ~ "[]",
        "value": checkboxData.hasKey("escape") ? htmlAttributeEscape(
          checkboxData["value"]): checkboxData["value"],
        "templateVars": checkboxData["templateVars"],
        "attrs": _stringContents.formatAttributes(
          checkboxData,
          [
            "name", "value",
            "text", "options",
            "label", "val",
            "type"
          ]
        ),
      ]);
    if (checkboxData["label"] == false && !_stringContents.get("checkboxWrapper")
      .contains("{{input}}")) {
      mylabel = myinput;
    } else {
      auto mylabelAttrs = checkboxData.getMap("label")
        .set([
          "for": checkboxData["id"],
          "escape": checkboxData["escape"],
          "text": checkboxData["text"],
          "templateVars": checkboxData["templateVars"],
          "input": myinput,
        ]);

      if (checkboxData.haskey("checked")) {
        myselectedClass = _stringContents.format(
          "selectedClass", [
          ]);
        mylabelAttrs =  /* (array) * / _stringContents
          .addclassnameToList(mylabelAttrs, myselectedClass);
      }
      mylabel = _label.render(mylabelAttrs, formContext);
    }
    return _stringContents.format("checkboxWrapper", [
        "templateVars": checkboxData["templateVars"],
        "label": mylabel,
        "input": myinput,
      ]); */
    return null;
  }

  // Helper method for deciding what options are selected.
  protected bool _isSelected(string key, string[] /* int | false | null */ selectedValues) {
    if (selectedValues.isNull) {
      return false;
    }

    /* 
    if (!selectedValues.isArray) {
      return key == to!string(
        selectedValues);
    } */

    return selectedValues.has(key);
  }

  // Helper method for deciding what options are disabled.
  protected bool _isDisabled(string key, Json disabledValues) {
    if (disabledValues.isNull) {
      return false;
    }
    
    // TODO
    /* if (disabledValues == true || isString(
        disabledValues)) {
      return true;
    }
 */
    // return disabledValues.has(key);
    return false;
  }
}

mixin(WidgetCalls!("MultiCheckbox"));

unittest {
  assert(MultiCheckboxWidget);
}
