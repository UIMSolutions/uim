/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.templaters.html;

import uim.views;
@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
} 

class DHtmlTemplater : DTemplater {
  mixin(TemplaterThis!("Html"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    _templates 
       // Head
      .set("meta", "<meta{{attrs}}>")
      .set("metalink", "<link href=\"{{url}}\"{{attrs}}>")
      .set("link", "<a href=\"{{url}}\"{{attrs}}>{{content}}</a>")
      .set("charset", "<meta charset=\"{{charset}}\">")
      // table
      .set("tableheader", "<th{{attrs}}>{{content}}</th>")
      .set("tableheaderrow", "<tr{{attrs}}>{{content}}</tr>")
      .set("tablecell", "<td{{attrs}}>{{content}}</td>")
      .set("tablerow", "<tr{{attrs}}>{{content}}</tr>")
      // tag
      .set("tag", "<{{tag}}{{attrs}}>{{content}}</{{tag}}>")
      .set("tagstart", "<{{tag}}{{attrs}}>")
      .set("tagend", "</{{tag}}>")
      .set("tagselfclosing", "<{{tag}}{{attrs}}/>")
      // para
      .set("para", "<p{{attrs}}>{{content}}</p>")
      .set("parastart", "<p{{attrs}}>")
      // style
      .set("css", "<link rel=\"{{rel}}\" href=\"{{url}}\"{{attrs}}>")
      .set("style", "<style{{attrs}}>{{content}}</style>")
      .set("mailto", "<a href=\"mailto:{{url}}\"{{attrs}}>{{content}}</a>")
      .set("image", "<img src=\"{{url}}\"{{attrs}}>")
      .set("ul", "<ul{{attrs}}>{{content}}</ul>")
      .set("ol", "<ol{{attrs}}>{{content}}</ol>")
      .set("li", "<li{{attrs}}>{{content}}</li>")
      .set("block", "<div{{attrs}}>{{content}}</div>")
      .set("blockstart", "<div{{attrs}}>")
      .set("blockend", "</div>")
      .set("button", `<button{{attrs}}>{{text}}</button>`) // Used for button elements in button().
      .set("checkbox", `<input type="checkbox" name="{{name}}" value="{{value}} "{{attrs}}>`) // Used for checkboxes in checkbox() and multiCheckbox().
      .set("checkboxFormGroup", `{{label}}`) // Input group wrapper for checkboxes created via control().
      .set("checkboxWrapper", `<div class="checkbox">{{label}}</div>`) // Wrapper container for checkboxes.
      .set("error", `<div class=" error - message" id="{{id}}">{{content}}</div>`) // Error message wrapper elements.
      .set("errorList", `<ul>{{content}}</ul>`) // Container for error items.
      .set("errorItem", `<li>{{text}}</li>`) // Error item wrapper.
      .set("file", `<input type=" file" name="{{name}}" {{attrs}}>`) // File input used by file().
      .set("fieldset", `<fieldset{{attrs}}>{{content}}</fieldset>`) // Fieldset element used by allControls().
      .set("formStart", `<form{{attrs}}>`) // Open tag used by create().
      .set("formEnd", `</form>`) // Close tag used by end().
      .set("formGroup", `{{label}}{{input}}`) // General grouping container for control(). Defines input/label ordering.
      .set("hiddenBlock", `<div style="d isplay: none; ">{{content}}</div>`) // Wrapper content used to hide other content.
      // Script
      .set("javascriptblock", "<script{{attrs}}>{{content}}</script>")
      .set("javascriptstart", "<script>")
      .set("javascriptlink", "<script src=\"{{url}}\"{{attrs}}></script>")
      .set("javascriptend", "</script>")
      // input
      .set("input", `<input type="{{type}}" name="{{name}}"{{attrs}}>`) // Generic input element.
      .set("inputSubmit", `<input type="{{type}}"{{attrs}}>`) // Submit input element.
      .set("inputContainer", `<div class="input{{type}} {{required}}">{{content}}</div>`) // Container element used by control().
      .set("inputContainerError", `<div class="input{{type}} {{required}} error">{{content}}{{error}}</div>`) // Container element used by control() when a field has an error.
      .set("label", `<label{{attrs}}>{{text}}</label>`) // Label element when inputs are not nested inside the label.
      .set("nestingLabel", `{{hidden}}<label{{attrs}}>{{input}}{{text}}</label>`) // Label element used for radio and multi-checkbox inputs.
      .set("legend", `<legend>{{text}}</legend>`) // Legends created by allControls()
      .set("multicheckboxTitle", `<legend>{{text}}</legend>`) // Multi-Checkbox input set title element.
      .set("multicheckboxWrapper", `<fieldset{{attrs}}>{{content}}</fieldset>`) // Multi-Checkbox wrapping container.
      .set("option", `<option value="{{value}} {{attrs}}>{{text}}</option>`) // Option element used in select pickers.
      .set("optgroup", `<optgroup label="{{label}}"{{attrs}}>{{content}}</optgroup>`) // Option group element used in select pickers.
      .set("select", `<select name="{{name}}"{{attrs}}>{{content}}</select>`) // Select element,
      .set("selectMultiple", `<select name="{{name}}[]" multiple=" multiple"{{attrs}}>{{content}}</select>`) // Multi-select element,
      .set("radio", `<input type=" radio" name="{{name}}" value="{{value}}"{{attrs}}>`) // Radio input element,
      .set("radioWrapper", `{{label}}`) // Wrapping container for radio input/label,
      .set("textarea", `<textarea name="{{name}}"{{attrs}}>{{value}}</textarea>`) // Textarea input element,
      .set("submitContainer", `<div class=" submit">{{content}}</div>`) // Container for submit buttons.
      // Javascript
      .set("confirmJs", `{{confirm}}`) // Confirm javascript template for postLink()
      .set("selectedClass", `selected`) // selected class
      .set("requiredClass", `required`);// required class

    return true;
  }
}

mixin(TemplaterCalls!("Html"));
