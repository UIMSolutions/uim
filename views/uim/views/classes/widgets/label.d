module uim.views.classes.widgets.label;

import uim.views;

@safe:

/**
 * Form "widget" for creating labels.
 *
 * Generally this element is used by other widgets,
 * and FormHelper itself.
 */
class DLabelWidget : DWidget {
    mixin(WidgetThis!("Label"));

    // The template to use.
    protected string _labelTemplate = "label";

    /* 
    protected StringTemplate _stringTemplate;


    /**
     * Constructor.
     *
     * This class uses the following template:
     *
     * - `label` Used to generate the label for a radio button.
     *  Can use the following variables `attrs`, `text` and `input`.
     * Params:
     * \UIM\View\StringTemplate mytemplates Templates list.
     * /
    this(DStringTemplate mytemplates) {
        _stringTemplate = mytemplates;
    }

    /**
     * Render a label widget.
     *
     * Accepts the following keys in mydata:
     *
     * - `text` The text for the label.
     * - `input` The input that can be formatted into the label if the template allows it.
     * - `escape` Set to false to disable HTML escaping.
     *
     * All other attributes will be converted into HTML attributes.
     * /
    string render(IData[string] renderData, IContext formContext) {
        renderData.update([
            "text": StringData,
            "input": StringData,
            "hidden": StringData,
            "escape": BoolData(true),
            "templateVars": ArrayData(),
        ]);

        return _stringTemplate.format(_labelTemplate, [
                "text": renderData["escape"] ? h(renderData["text"]): renderData["text"],
                "input": renderData["input"],
                "hidden": renderData["hidden"],
                "templateVars": renderData["templateVars"],
                "attrs": _stringTemplate.formatAttributes(renderData, [
                        "text", "input", "hidden"
                    ]),
            ]);
    }

    array secureFields(array data) {
        return null;
    } */
}
    mixin(WidgetCalls!("Label"));
