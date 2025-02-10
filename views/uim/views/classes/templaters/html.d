/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.templaters.html;

import uim.views;

@safe:
unittest {
  writeln("-----  ", __MODULE__, "\t  -----");
}

class DHtmlTemplater : DTemplater {
  mixin(TemplaterThis!("Html"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    _templates 
      // Used for button elements in button().
    .set("button", `<button{{attrs}}>{{text}}</button>`) 
    // Used for checkboxes in checkbox() and multiCheckbox().
      .set("checkbox", `<input type="checkbox" name="{{name}}" value="{{value}} "{{attrs}}>`) // Input group wrapper for checkboxes created via control().
      .set("checkboxFormGroup", `{{label}}`) // Wrapper container for checkboxes.
      .set("checkboxWrapper", `<div class="checkbox">{{label}}</div>`) // Error message wrapper elements.
      .set("error", `<div class=" error - message" id="{{id}}">{{content}}</div>`) // Container for error items.
      .set("errorList", `<ul>{{content}}</ul>`) // Error item wrapper.
      .set("errorItem", `<li>{{text}}</li>`) // File input used by file().
      .set("file", `<input type=" file" name="{{name}}" {{attrs}}>`) // Fieldset element used by allControls().
      .set("fieldset", `<fieldset{{attrs}}>{{content}}</fieldset>`) // Open tag used by create().
      .set("formStart", `<form{{attrs}}>`) // Close tag used by end().
      .set("formEnd", `</form>`) // General grouping container for control(). Defines input/label ordering.
      .set("formGroup", `{{label}}{{input}}`) // Wrapper content used to hide other content.
      .set("hiddenBlock", `<div style="d isplay: none; ">{{content}}</div>`) // Generic input element.
      .set("input", `<input type="{{type}}" name="{{name}}"{{attrs}}>`) // Submit input element.
      .set("inputSubmit", `<input type="{{type}}"{{attrs}}>`) // Container element used by control().
      .set("inputContainer", `<div class="input{{type}} {{required}}">{{content}}</div>`) // Container element used by control() when a field has an error.
      .set("inputContainerError", `<div class="input{{type}} {{required}} error">{{content}}{{error}}</div>`) // Label element when inputs are not nested inside the label.
      .set("label", `<label{{attrs}}>{{text}}</label>`) // Label element used for radio and multi-checkbox inputs.
      .set("nestingLabel", `{{hidden}}<label{{attrs}}>{{input}}{{text}}</label>`) // Legends created by allControls()
      .set("legend", `<legend>{{text}}</legend>`) // Multi-Checkbox input set title element.
      .set("multicheckboxTitle", `<legend>{{text}}</legend>`) // Multi-Checkbox wrapping container.
      .set("multicheckboxWrapper", `<fieldset{{attrs}}>{{content}}</fieldset>`) // Option element used in select pickers.
      .set("option", `<option value="{{value}} {{attrs}}>{{text}}</option>`) // Option group element used in select pickers.
      .set("optgroup", `<optgroup label="{{label}}"{{attrs}}>{{content}}</optgroup>`) // Select element,
      .set("select", `<select name="{{name}}"{{attrs}}>{{content}}</select>`) // Multi-select element,
      .set("selectMultiple", `<select name="{{name}}[]" multiple=" multiple"{{attrs}}>{{content}}</select>`) // Radio input element,
      .set("radio", `<input type=" radio" name="{{name}}" value="{{value}}"{{attrs}}>`) // Wrapping container for radio input/label,
      .set("radioWrapper", `{{label}}`) // Textarea input element,
      .set("textarea", `<textarea name="{{name}}"{{attrs}}>{{value}}</textarea>`) // Container for submit buttons.
      .set("submitContainer", `<div class=" submit">{{content}}</div>`) // Confirm javascript template for postLink()
      .set("confirmJs", `{{confirm}}`) // selected class
      .set("selectedClass", `selected`) // required class
      .set("requiredClass", `required`);

    return true;
  }
}

mixin(TemplaterCalls!("Html"));
