module uim.views.classes.widgets.widget;

import uim.views;

@safe:

/**
 * Basic input class.
 *
 * This input class can be used to render basic simple
 * input elements like hidden, text, email, tel and other types.
 */
class DWidget : IWidget {
  mixin TConfigurable!();

  this() {
    initialize;
  }

  this(DStringTemplate newTemplate) {
    this.stringTemplate(newTemplate);
  }

  this(string newName) {
    this();
    this.name(newName);
  }

  bool initialize(IData[string] initData = null) {
    configuration(MemoryConfiguration);
    setConfigurationData([
      "name": StringData(),
      // "val": NullData(null),
      "type": StringData("text"),
      "escape": BooleanData(true),
      "templateVars": ArrayData
    ]);
    setConfigurationData(initData);

    return true;
  }

  mixin(TProperty!("string", "name"));
  mixin(TProperty!("DStringTemplate", "stringTemplate"));

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
     * @param \UIM\View\Form\IContext mycontext The current form context.
     */
  string render(IData[string] renderData, IContext formContext) {
    /* 
    auto mydata = this.mergeDefaults(buildData, formContext);

    mydata["value"] = mydata["val"];
    unset(mydata["val"]);
    if (mydata["value"] == false) {
      // explicitly convert to 0 to avoid empty string which is marshaled as null
      mydata["value"] = "0";
    }

    if (auto fieldName = mydata.get("fieldName", null)) {
      if (mydata["type"] == "number" && !mydata.isSet("step")) {
        mydata = this.setStep(mydata, formContext, fieldName);
      }
      mytypesWithMaxLength = ["text", "email", "tel", "url", "search"];
      if (
        !array_key_exists("maxlength", mydata)
        && in_array(mydata["type"], mytypesWithMaxLength, true)
        ) {
        mydata = this.setMaxLength(mydata, formContext, fieldName);
      }
    }

    return _stringTemplate.format("input", [
        "name": mydata["name"],
        "type": mydata["type"],
        "templateVars": mydata["templateVars"],
        "attrs": _stringTemplate.formatAttributes(
          mydata,
          ["name", "type"]
        ),
      ]); */

    return null;
  }

  /**
     * Merge default values with supplied data.
     * Params:
     * IData[string] mydata Data array
     * @param \UIM\View\Form\IContext mycontext Context instance.
     * /
  protected IData[string] mergeDefaults(array data, IContext mycontext) {
    mydata += this.defaults;

    if (isSet(mydata["fieldName"]) && !array_key_exists("required", mydata)) {
      mydata = this.setRequired(mydata, mycontext, mydata["fieldName"]);
    }
    return mydata;
  }

  /**
     * Set value for "required" attribute if applicable.
     * Params:
     * IData[string] mydata Data array
     * @param \UIM\View\Form\IContext mycontext Context instance.
     * @param string aFieldName Field name.
     * /
  protected IData[string] setRequired(array data, IContext mycontext, string aFieldName) {
    if (
      mydata["disabled"].isEmpty && (
          (isSet(mydata["type"])
            && mydata["type"] != "hidden"
        )
        || !mydata.isSet("type")
      )
        && mycontext.isRequired(myfieldName)
      ) {
      mydata["required"] = true;
    }
    return mydata;
  }

  /**
     * Set value for "maxlength" attribute if applicable.
     * Params:
     * IData[string] mydata Data array
     * @param \UIM\View\Form\IContext mycontext Context instance.
     * @param string aFieldName Field name.
     * /
  protected IData[string] setMaxLength(array data, IContext mycontext, string aFieldName) {
    mymaxLength = mycontext.getMaxLength(aFieldName);
    if (mymaxLength!isNull) {
      mydata["maxlength"] = min(mymaxLength, 100000);
    }
    return mydata;
  }

  /**
     * Set value for "step" attribute if applicable.
     * Params:
     * IData[string] mydata Data array
     * @param \UIM\View\Form\IContext mycontext Context instance.
     * @param string aFieldName Field name.
     * /
  protected IData[string] setStep(array data, IContext mycontext, string aFieldName) {
    mydbType = mycontext.type(myfieldName);
    myfieldDef = mycontext.attributes(myfieldName);

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
    /* if (!dataToRender.isSet("name") || dataToRender["name"].isEmpty) {
      return null;
    }
    return [dataToRender["name"]]; */

    return null;
  }
}
