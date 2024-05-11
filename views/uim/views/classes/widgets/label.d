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

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }
    /**
     * This class uses the following template:
     * - `label` Used to generate the label for a radio button.
     *  Can use the following variables `attrs`, `text` and `input`.
     */
    this(DStringContents newTemplates) {
        super(newTemplates);
    }

    // Render a label widget.
    override string render(Json[string] renderData, IContext formContext) {
        auto updatedData = renderData.merge([
            // `text` The text for the label.
            "text": "".toJson,
            // `input` The input that can be formatted into the label if the template allows it.
            "input": "".toJson,
            "hidden": "".toJson,
            // `escape` Set to false to disable HTML escaping.
            "escape": true.toJson,
            "templateVars": Json.emptyArray(),
        ]);

        return null; 
        _stringContents.format(_labelTemplate, [
                "text": updatedData["escape"] ? htmlAttributeEscape(updatedData["text"]): updatedData["text"],
                "input": updatedData["input"],
                "hidden": updatedData["hidden"],
                "templateVars": updatedData["templateVars"],
                "attrs": _stringContents.formatAttributes(updatedData, [
                        "text", "input", "hidden"
                    ]),
            ]); */
    }
}

mixin(WidgetCalls!("Label"));
