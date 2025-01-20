/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.widgets.label;

import uim.views;

@safe:

 unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}

// Form "widget" for creating labels.
class DLabelWidget : DWidget {
    mixin(WidgetThis!("Label"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        _labelTemplate = "label";
        
        return true;
    }

    // The template to use.
    protected string _labelTemplate;

    /**
     * This class uses the following template:
     * - `label` Used to generate the label for a radio button.
     * Can use the following variables `attrs`, `text` and `input`.
     */
    this(DStringContents newTemplates) {
        // super(newTemplates);
    }

    // Render a label widget.
    override string render(Json[string] options, IFormContext formContext) {
        // set defaults
        options.merge("text", ""); // `text` The text for the label.
        options.merge("input", ""); // `input` The input that can be formatted into the label if the template allows it.
        options.merge("hidden", "");
        options.merge("escape", true); // `escape` Set to false to disable HTML escaping.
        options.merge("templateVars", Json.emptyArray());

        Json[string] settings = MapHelper.create!(string, Json)
            .set("text", options.getBoolean("escape") ? htmlAttributeEscape(options.getString("text")) : options.getString("text"))
            .set("input", options.get("input"))
            .set("hidden", options.get("hidden"))
            .set("templateVars", options.get("templateVars"));
            /* .set("attrs", _stringContents.formatAttributes(options, [
                "text", "input", "hidden"
            ])) * /); */
        return _stringContents.format(_labelTemplate, settings);
    }
}

mixin(WidgetCalls!("Label"));

unittest {
    assert(LabelWidget);
}