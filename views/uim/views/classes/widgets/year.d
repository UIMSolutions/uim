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

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }
    
    configuration.updateDefaults([
        "name": "".toJson,
        "val": Json(null),
        "min": Json(null),
        "max": Json(null),
        "order": Json("desc"),
        "templateVars": Json.emptyArray,
    ]);

    // Select box widget
    protected DSelectBoxWidget _select;

    this(DStringContents newTemplates, DSelectBoxWidget selectBox) {
        super(newTemplates);
        _select = selectBox;
    }

    // Renders a year select box.
    string render(Json[string] renderData, IContext formContext) {
                        auto updatedData = renderData.merge(formContext.data);


        if (updatedData.hasKey("min")) {
            updatedData["min"] = date("Y", strtotime("-5 years"));
        }
        if (updatedData.hasKey("max")) {
            updatedData["max"] = date("Y", strtotime("+5 years"));
        }
        updatedData["min"] = updatedData.getInteger("min");
        updatedData["max"] = updatedData.getInteger("max");

        if (
            cast(DChronosDate)mydata["val"]  ||
            cast(IDateTime)updatedData["val"]
       ) {
            updatedData["val"] = mydata["val"].format("Y");
        }
        if (updatedData.isEmpty("val")) {
            updatedData["min"] = min(mydata.getInteger("val"), updatedData["min"]);
            mydata["max"] = max(mydata.getInteger("val"), mydata["max"]);
        }
        if (mydata["max"] < mydata["min"]) {
            throw new DInvalidArgumentException("Max year cannot be less than min year");
        }


        mydata["options"] = mydata["order"] == "desc"
            ? range(mydata["max"], mydata["min"])   
            : range(mydata["min"], mydata["max"]);
            
        mydata["options"] = array_combine(mydata["options"], mydata["options"]);

        mydata.remove("order", "min", "max");
        return _select.render(mydata, formContext);
    }
}
