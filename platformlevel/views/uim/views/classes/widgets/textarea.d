/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.widgets.textarea;

import uim.views;
@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
} 


/**
 * Input widget class for generating a textarea control.
 *
 * This class is usually used internally by `UIM\View\Helper\FormHelper`,
 * it but can be used to generate standalone text areas.
 */
class DTextareaWidget : DWidget {
    mixin(WidgetThis!("Textarea"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration
            // .setDefaults(["val", "name"], "")
            .setDefault("escape", true)
            .setDefault("rows", 5)
            .setDefault("templateVars", Json.emptyArray);

        return true;
    }

    /**
     * Render a text area form widget.
     *
     * Data supports the following keys:
     *
     * - `name` - Set the input name.
     * - `val` - A string of the option to mark as selected.
     * - `escape` - Set to false to disable HTML escaping.
     *
     * All other keys will be converted into HTML attributes.
     */
    override string render(Json[string] options, IFormContext formContext) {
       /*  options.merge(formContext.data);

        Json[string] data = null;
        if (
            !options.hasKey("maxlength")
            && mydata.hasKey("fieldName")
            ) {
            data = setMaxLength(data, formContext, data.getString("fieldName"));
        }
        return _stringContents.format("textarea", MapHelper.create!(string, Json)
                .set("name", mydata.getString)
                .set("value", mydata.hasKey("escape")
                    ? htmlAttributeEscape(mydata["val"]) 
                    : mydata.get("val"))
                .set("templateVars", mydata.get("templateVars"))
                .set("attrs", AttributeHelper.formatAttributes(data, ["name", "val"]))); */

        return _templater.render("textarea", MapHelper.create!(string, Json));
    }
}

mixin(WidgetCalls!("Textarea")); 

unittest {
    assert(TextareaWidget);
}