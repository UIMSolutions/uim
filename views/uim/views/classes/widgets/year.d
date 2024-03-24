module uim.views.classes.widgets.year;

import uim.views;

@safe:

/**
 * Input widget class for generating a calendar year select box.
 *
 * This class is usually used internally by `UIM\View\Helper\FormHelper`,
 * it but can be used to generate standalone calendar year select boxes.
 */
class YearWidget : DWidget {
        mixin(WidgetThis!("Year"));

    /* 
    // Data defaults.
    protected IData[string] _defaultData = [
        "name": StringData(""),
        "val": null,
        "min": null,
        "max": null,
        "order": StringData("desc"),
        "templateVars": ArrayData,
    ];

    // Select box widget
    protected SelectBoxWidget my_select;

    /**
     * Constructor
     * Params:
     * \UIM\View\StringTemplate mytemplates Templates list.
     * @param \UIM\View\Widget\SelectBoxWidget myselectBox Selectbox widget instance.
     * /
    this(DStringTemplate mytemplates, SelectBoxWidget myselectBox) {
       super(mytemplates);
_select = myselectBox;
    }
    
    /**
     * Renders a year select box.
     * Params:
     * IData[string] mydata Data to render with.
     * @param \UIM\View\Form\IContext mycontext The current form context.
     * /
    string render(IData[string] renderData, IContext mycontext) {
        mergedData += this.mergeDefaults(renderData, mycontext);

        if (mergedData("min")) {
            mergedData["min"] = date("Y", strtotime("-5 years"));
        }
        if (mergedData("max")) {
            mergedData["max"] = date("Y", strtotime("+5 years"));
        }
        mergedData["min"] = mergedData.getInteger("min");
        mergedData["max"] = mergedData.getInteger("max");

        if (
            cast(ChronosDate)mydata["val"]  ||
            cast(IDateTime)mergedData["val"]
        ) {
            mergedData["val"] = mydata["val"].format("Y");
        }
        if ((mergedData.isEmpty("val")) {
            mergedData["min"] = min(mydata.getInteger("val"), mergedData["min"]);
            mydata["max"] = max(mydata.getInteger("val"), mydata["max"]);
        }
        if (mydata["max"] < mydata["min"]) {
            throw new InvalidArgumentException("Max year cannot be less than min year");
        }
        if (mydata["order"] == "desc") {
            mydata["options"] = range(mydata["max"], mydata["min"]);
        } else {
            mydata["options"] = range(mydata["min"], mydata["max"]);
        }
        mydata["options"] = array_combine(mydata["options"], mydata["options"]);

        mydata.remove("order");
        mydata.remove("min");
        mydata.remove("max");

        return _select.render(mydata, mycontext);
    } */
}
