module uim.views.classes.widgets.label;

import uim.views;

@safe:

/**
 * Form "widget" for creating labels.
 *
 * Generally this element is used by other widgets, * and FormHelper itself.
 */
class DLabelWidget : DWidget {
    mixin(WidgetThis!("Label"));

    // The template to use.
    protected string _labelTemplate = "label";

    /* 
    /**
     * Constructor.
     *
     * This class uses the following template:
     *
     * - `label` Used to generate the label for a radio button.
     *  Can use the following variables `attrs`, `text` and `input`.
     */
    this(DStringTemplate newTemplates) {
        super(newTemplates);
    }

    // Render a label widget.
    override string render(IData[string] renderData, IContext formContext) {
        auto myData = renderData.merge([
            // `text` The text for the label.
            "text": StringData(""),
            // `input` The input that can be formatted into the label if the template allows it.
            "input": StringData(""),
            "hidden": StringData(""),
            // `escape` Set to false to disable HTML escaping.
            "escape": BooleanData(true),
            "templateVars": ArrayData(),
        ]);

        return null; 
        /* _stringTemplate.format(_labelTemplate, [
                "text": myData["escape"] ? htmlAttribEscape(myData["text"]): myData["text"],
                "input": myData["input"],
                "hidden": myData["hidden"],
                "templateVars": myData["templateVars"],
                "attrs": _stringTemplate.formatAttributes(myData, [
                        "text", "input", "hidden"
                    ]),
            ]); */
    }
}

mixin(WidgetCalls!("Label"));
