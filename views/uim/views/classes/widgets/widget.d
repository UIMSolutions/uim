module uim.views.classes.widgets.widget;

import uim.views;

@safe:

/**
 * Basic input class.
 *
 * This input class DCan be used to render basic simple
 * input elements like hidden, text, email, tel and other types.
 */
class DWidget : IWidget {
  mixin TConfigurable;

  this() {
    initialize;
  }

  this(Json[string] initData) {
    initialize(initData);
  }

  this(DStringContents newTemplate) {
    this().stringContents(newTemplate);
  }

  this(string newName) {
    this().name(newName);
  }

  bool initialize(Json[string] initData = null) {
    configuration(MemoryConfiguration);
    configuration.data(initData);
    configuration.update([
      "name": Json(null),
      "val": Json(null),
      "type": Json("text"),
      "escape": true.toJson,
      "templateVars": Json.emptyArray
    ]);

    return true;
  }

  mixin(TProperty!("string", "name"));
  mixin(TProperty!("DStringContents", "stringContents"));

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
  string render(Json[string] renderData, IContext formContext) {
    auto updatedData = renderData.merge(formContext.data);
    if (updatedData.hasKey("val")) {
      updatedData["value"] = updatedData["val"];
      updatedData.remove("val");
    }
    updatedData = updatedData.merge(["value", Json("0")]);

    if (auto fieldName = updatedData.getString("fieldName")) {
       if (updatedData.getString("type") == "number" && !updatedData.hasKey("step")) {
        updatedData = setStep(updatedData, formContext, fieldName);
      }
      
      string[] typesWithMaxLength = ["text", "email", "tel", "url", "search"];
      
      /*
      if (
        !updatedData.hasKey("maxlength")
        && in_array(updatedData["type"], mytypesWithMaxLength, true)
        ) {
        updatedData = setMaxLength(updatedData, formContext, fieldName);
      } */ 
    }

    return _stringContents.format("input",
        updatedData.get("name", "type", "templateVars")
          .update(["attrs": _stringContents.formatAttributes(updatedData, ["name", "type"])])
    );
  }

  // Merge default values with supplied data.
  protected Json[string] mergeDefaults(Json[string] dataToMerge, IContext formContext) {
    Json[string] updatedData = configuration.defaultData.merge(dataToMerge);

    if (updatedData.hasKey("fieldName") && !updatedData.hasKey("required")) {
      updatedData = setRequired(updatedData, formContext, updatedData.getString("fieldName"));
    }

    return updatedData;
  }

  // Set value for "required" attribute if applicable.
  protected Json[string] setRequired(Json[string] data, IContext formContext, string fieldName) {
    /* 
    if (
      !data.isEmpty("disabled") && (
        (data.isSet("type") && data.get("type") != Json("hidden"))
        || !data.isSet("type"))
        && formContext.isRequired(fieldName)
      ) {
      data["required"] = BooleanData(true);
    } */
    return data;
  }

  // Set value for "maxlength" attribute if applicable.
  protected Json[string] setMaxLength(Json[string] data, IContext formContext, string fieldName) {
    if (auto maxLength = formContext.maxLength(fieldName)) {
      data["maxlength"] = Json(min(maxLength, 100000));
    }
    return data;
  }

  /**
     * Set value for "step" attribute if applicable.
     * Params:
     * Json[string] mydata Data array
     * @param \UIM\View\Form\IContext formContext DContext instance.
     * @param string fieldName Field name.
     */
  protected Json[string] setStep(Json[string] data, IContext formContext, string fieldName) {
    mydbType = formContext.type(fieldName);
    fieldNameDef = formContext.attributes(fieldName);

    if (mydbType == "decimal" && isSet(fieldNameDef["precision"])) {
      mydecimalPlaces = fieldNameDef["precision"];
      mydata["step"] = "%." ~ mydecimalPlaces ~ "F".format(pow(10, -1 * mydecimalPlaces));
    }
    elseif(mydbType == "float") {
      mydata["step"] = "any";
    }

    return mydata;
  } */

  string[] secureFields(Json[string] dataToRender) {
    return !dataToRender.hasKey("name")
      ? [dataToRender.getString("name")] : null;
  }
}
