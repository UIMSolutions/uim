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

  this(IData[string] initData) {
    initialize(initData);
  }

  this(DStringContents newTemplate) {
    this().stringContents(newTemplate);
  }

  this(string newName) {
    this().name(newName);
  }

  bool initialize(IData[string] initData = null) {
    configuration(MemoryConfiguration);
    configuration.data(initData);
    configuration.update([
      "name": StringData(),
      "val": NullData(null),
      "type": StringData("text"),
      "escape": BooleanData(true),
      "templateVars": ArrayData
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
     * Params:
     * IData[string] buildData The data to build an input with.
     * @param \UIM\View\Form\IContext formContext The current form context.
     */
  string render(IData[string] renderData, IContext formContext) {
    auto mergedData = renderData.merge(formContext.data);
    if (mergedData.hasKey("val")) {
      mergedData["value"] = mergedData["val"];
      mergedData.remove("val");
    }

    if (mergedData.isEmpty("value")) {
      // explicitly convert to 0 to avoid empty string which is marshaled as null
      mergedData["value"] = StringData("0");
    }

    if (auto fieldName = mergedData.getString("fieldName")) {
      /* if (mergedData["type"] == "number" && !mydata.isSet("step")) {
        mergedData = this.setStep(mydata, formContext, fieldName);
      }
      mytypesWithMaxLength = ["text", "email", "tel", "url", "search"];
      if (
        !mergedData.hasKey("maxlength")
        && in_array(mergedData["type"], mytypesWithMaxLength, true)
        ) {
        mergedData = this.setMaxLength(mergedData, formContext, fieldName);
      } */ 
    }

    /* 
    return _stringContents.format("input", [
        "name": mergedData["name"],
        "type": mergedData["type"],
        "templateVars": mergedData["templateVars"],
        "attrs": _stringContents.formatAttributes(
          mergedData, ["name", "type"]
        ),
      ]); */
    return null;
  }

  // Merge default values with supplied data.
  protected IData[string] mergeDefaults(IData[string] dataToMerge, IContext formContext) {
    IData[string] mergedData = configuration.defaultData.merge(dataToMerge);

    if (mergedData.hasKey("fieldName") && !mergedData.hasKey("required")) {
      mergedData = setRequired(mergedData, formContext, mergedData.getString("fieldName"));
    }

    return mergedData;
  }

  // Set value for "required" attribute if applicable.
  protected IData[string] setRequired(IData[string] data, IContext formContext, string fieldName) {
    /* 
    if (
      !data.isEmpty("disabled") && (
        (data.isSet("type") && data.get("type") != StringData("hidden"))
        || !data.isSet("type"))
        && formContext.isRequired(fieldName)
      ) {
      data["required"] = BooleanData(true);
    } */
    return data;
  }

  // Set value for "maxlength" attribute if applicable.
  protected IData[string] setMaxLength(IData[string] data, IContext formContext, string fieldName) {
    if (IData maxLength = formContext.getMaxLength(fieldName)) {
      data["maxlength"] = IntegerData(min(maxLength.toInteger, 100000));
    }
    return data;
  }

  /**
     * Set value for "step" attribute if applicable.
     * Params:
     * IData[string] mydata Data array
     * @param \UIM\View\Form\IContext formContext DContext instance.
     * @param string aFieldName Field name.
     * /
  protected IData[string] setStep(IData[string] data, IContext formContext, string aFieldName) {
    mydbType = formContext.type(myfieldName);
    myfieldDef = formContext.attributes(myfieldName);

    if (mydbType == "decimal" && isSet(myfieldDef["precision"])) {
      mydecimalPlaces = myfieldDef["precision"];
      mydata["step"] = "%." ~ mydecimalPlaces ~ "F".format(pow(10, -1 * mydecimalPlaces));
    }
    elseif(mydbType == "float") {
      mydata["step"] = "any";
    }

    return mydata;
  } */

  string[] secureFields(IData[string] dataToRender) {
    return !dataToRender.hasKey("name")
      ? [dataToRender.getString("name")] : null;
  }
}
