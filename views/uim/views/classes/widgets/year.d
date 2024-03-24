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
       _select = myselectBox;
       _stringTemplate = mytemplates;
    }
    
    /**
     * Renders a year select box.
     * Params:
     * IData[string] mydata Data to render with.
     * @param \UIM\View\Form\IContext mycontext The current form context.
     * /
    string render(IData[string] renderData, IContext mycontext) {
        mydata += this.mergeDefaults(mydata, mycontext);

        if (mydata.isEmpty("min")) {
            mydata["min"] = date("Y", strtotime("-5 years"));
        }
        if (mydata.isEmpty("max")) {
            mydata["max"] = date("Y", strtotime("+5 years"));
        }
        mydata["min"] = mydata.getInteger("min");
        mydata["max"] = mydata.getInteger("max");

        if (
            cast(ChronosDate)mydata["val"]  ||
            cast(IDateTime)mydata["val"]
        ) {
            mydata["val"] = mydata["val"].format("Y");
        }
        if ((mydata.isEmpty("val")) {
            mydata["min"] = min((int)mydata["val"], mydata["min"]);
            mydata["max"] = max((int)mydata["val"], mydata["max"]);
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
