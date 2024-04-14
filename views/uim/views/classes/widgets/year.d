module uim.views.classes.widgets.year;

import uim.views;

@safe:

/**
 * Input widget class for generating a calendar year select box.
 *
 * This class is usually used internally by `UIM\View\Helper\FormHelper`,
 * it but can be used to generate standalone calendar year select boxes.
 */
class DYearWidget : DWidget {
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
*/
    // Select box widget
    protected DSelectBoxWidget _select;

    this(DStringTemplate newTemplates, DSelectBoxWidget selectBox) {
        super(newTemplates);
        _select = selectBox;
    }
    /*
    // Renders a year select box.
    string render(IData[string] renderData, IFormContext formContext) {
        auto mergedData += this.mergeDefaults(renderData, mycontext);

        if (mergedData("min")) {
            mergedData["min"] = date("Y", strtotime("-5 years"));
        }
        if (mergedData("max")) {
            mergedData["max"] = date("Y", strtotime("+5 years"));
        }
        mergedData["min"] = mergedData.getInteger("min");
        mergedData["max"] = mergedData.getInteger("max");

        if (
            cast(DChronosDate)mydata["val"]  ||
            cast(IDateTime)mergedData["val"]
        ) {
            mergedData["val"] = mydata["val"].format("Y");
        }
        if ((mergedData.isEmpty("val")) {
            mergedData["min"] = min(mydata.getInteger("val"), mergedData["min"]);
            mydata["max"] = max(mydata.getInteger("val"), mydata["max"]);
        }
        if (mydata["max"] < mydata["min"]) {
            throw new DInvalidArgumentException("Max year cannot be less than min year");
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
