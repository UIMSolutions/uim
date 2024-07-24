module uim.views.classes.widgets.widget;

import uim.views;

@safe:

/**
 * Basic input class.
 *
 * This input class DCan be used to render basic simple
 * input elements like hidden, text, email, tel and other types.
 */
class DWidget : UIMObject, IWidget {

  this() {
    super();
  }

  this(Json[string] initData) {
    super(initData);
  }

  this(DStringContents newTemplate) {
    this().stringContents(newTemplate);
  }

  this(string newName) {
    super(newName);
  }

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
        return false;
    }
    configuration
      .merge(["name", "val"], Json(null)),
      .merge("type", "text")
      .merge("escape", true)
      .merge("templateVars", Json.emptyArray);

    return true;
  }

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
      updatedData.set("value", updatedData.get("val"));
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
        && isIn(updatedData["type"], mytypesWithMaxLength, true)
       ) {
        updatedData = setMaxLength(updatedData, formContext, fieldName);
      } */ 
    }

    return _stringContents.format("input",
        updatedData.get("name", "type", "templateVars")
          .setPath(["attrs": _stringContents.formatAttributes(updatedData, ["name", "type"])])
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
        (data.hasKey("type") && data.get("type") != Json("hidden"))
        || !data.hasKey("type"))
        && formContext.isRequired(fieldName)
     ) {
      data.set("required", true);
    } */
    return data;
  }

  // Set value for "maxlength" attribute if applicable.
  protected Json[string] setMaxLength(Json[string] data, IContext formContext, string fieldName) {
    if (auto maxLength = formContext.maxLength(fieldName)) {
      data.set("maxlength", Json(min(maxLength, 100000)));
    }
    return data;
  }

  // Set value for "step" attribute if applicable.
  protected Json[string] setStep(Json[string] data, IContext formContext, string fieldName) {
    auto mydbType = formContext.type(fieldName);
    auto fieldNameDef = formContext.attributes(fieldName);

    if (mydbType == "decimal" && fieldNameDef.hasKey("precision")) {
      mydecimalPlaces = fieldNameDef["precision"];
      data.set("step", "%." ~ mydecimalPlaces ~ "F".format(pow(10, -1 * mydecimalPlaces)));
    }
    else if(mydbType == "float") {
      data.set("step", "any");
    }

    return data;
  } 

  string[] secureFields(Json[string] dataToRender) {
    return !dataToRender.hasKey("name")
      ? [dataToRender.getString("name")] : null;
  }
}
