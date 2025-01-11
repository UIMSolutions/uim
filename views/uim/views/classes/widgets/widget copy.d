/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.widgets.widget;

import uim.views;

@safe:

unittest {
  writeln("-----  ", __MODULE__, "\t  -----");
}

/**
 * Basic input class.
 *
 * This input class DCan be used to render basic simple
 * input elements like hidden, text, email, tel and other types.
 */
class DWidget : UIMObject, IWidget {
  mixin(WidgetThis!());

  mixin(TProperty!("DStringContents", "stringContents"));
  mixin(TProperty!("DTemplater", "templater"));

  /**
     * Render a text widget or other simple widget like email/tel/number.
     *
     * This method accepts a number of keys:
     *
     * - `name` The name attribute.
     * - `val` The value attribute.
     * - `escape` Set to false to disable escaping on all attributes.
     *
     * Any other keys provided in mydata will be converted into HTML attributes.
     */
  string render(Json[string] data, IContext formContext) {
    data.merge(formContext.data);
    if (data.hasKey("val")) {
      data.set("value", data.shift("val"));
    }
    data.merge("value", "0");

    auto typeName = data.getString("type");
    /*
    if (auto fieldName = data.getString("fieldName")) {
      if (typeName == "number" && !data.hasKey("step")) {
        data = setStep(data, formContext, fieldName);
      }

      if (!data.hasKey("maxlength") && typeName.isTypeWithMaxLength) {
        data = setMaxLength(data, formContext, fieldName);
      }
    }

    return _stringContents.format("input",
      data.get("name", "type", "templateVars")
        .setPath([
          "attrs": _stringContents.formatAttributes(data, ["name", "type"])
        ])
    ); */
    return null;
  }

  bool isTypeWithMaxLength(string typeName) {
    // return typeName.lower.isIn(["text", "email", "tel", "url", "search"]);
    return false;
  }

  // Merge default values with supplied data.
  protected Json[string] mergeDefaults(Json[string] dataToMerge, IContext formContext) {
    Json[string] renderData = configuration.defaultData.merge(dataToMerge);

    if (renderData.hasKey("fieldName") && !renderData.hasKey("required")) {
      renderData = setRequired(renderData, formContext, renderData.getString("fieldName"));
    }

    return renderData;
  }

  // Set value for "required" attribute if applicable.
  protected Json[string] setRequired(Json[string] data, IContext formContext, string fieldName) {
    if (
      !data.isEmpty("disabled") && data.getString("type") != "hidden" && formContext.isRequired(
        fieldName)
      ) {
      data.set("required", true);
    }
    return data;
  }

  // Set value for "maxlength" attribute if applicable.
  protected Json[string] setMaxLength(Json[string] data, IContext formContext, string fieldName) {
    if (auto maxLength = formContext.maxLength(fieldName)) {
      data.set("maxlength", min(maxLength, 100000));
    }
    return data;
  }

  // Set value for "step" attribute if applicable.
  protected Json[string] setStep(Json[string] data, IContext formContext, string fieldName) {
    /*  auto mydbType = formContext.type(fieldName);
    auto fieldNameDef = formContext.attributes(fieldName);

    if (mydbType == "decimal" && fieldNameDef.hasKey("precision")) {
      mydecimalPlaces = fieldNameDef["precision"];
      data.set("step", "%." ~ mydecimalPlaces ~ "F".format(pow(10, -1 * mydecimalPlaces)));
    } else if (mydbType == "float") {
      data.set("step", "any");
    }

    return data; */
    return null;
  }

  string[] secureFields(Json[string] options) {
    return options.hasKey("name")
      ? [options.getString("name")] : null;
  }
}
