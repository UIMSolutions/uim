module uim.views.classes.widgets.label;

import uim.views;

@safe:

/**
 * Form "widget" for creating labels.
 *
 * Generally this element is used by other widgets, * and FormHelper it
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
     * Can use the following variables `attrs`, `text` and `input`.
     */
    this(DStringContents newTemplates) {
        // super(newTemplates);
    }

    // Render a label widget.
    override string render(Json[string] renderData, IContext formContext) {
        /* renderData
            .merge("text", "") // `text` The text for the label.
            .merge("input", "") // `input` The input that can be formatted into the label if the template allows it.
            .merge("hidden", "")
            .merge("escape", true) // `escape` Set to false to disable HTML escaping.
            .merge("templateVars", Json.emptyArray());

        return _stringContents.format(_labelTemplate, createMap!(string, Json)
            .set("text", updatedData.hasKey("escape") ? htmlAttributeEscape(updatedData.get("text")): updatedData.get("text"))
            .set("input", updatedData.get("input"))
            .set("hidden", updatedData.get("hidden"))
            .set("templateVars", updatedData.get("templateVars"))
            /* .set("attrs", _stringContents.formatAttributes(updatedData, [
                "text", "input", "hidden"
            ])) * /); */
        return null;
    }
}

mixin(WidgetCalls!("Label"));
