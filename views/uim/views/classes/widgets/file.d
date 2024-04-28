module uim.views.classes.widgets.file;

import uim.views;

@safe:

/**
 * Input widget class for generating a file upload control.
 *
 * This class is usually used internally by `UIM\View\Helper\FormHelper`,
 * it but can be used to generate standalone file upload controls.
 */
class DFileWidget : DWidget {
    mixin(WidgetThis!("File"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration.updateDefaults([
            // `name` - Set the input name.
            "name": StringData(""),
            // `escape` - Set to false to disable HTML escaping.
            "escape": BooleanData(true),
            "templateVars": Json.emptyArray,
        ]);

        return true;
    }

    /**
     * Render a file upload form widget.
     *
     * Data supports the following keys:
     *
     *
     * All other keys will be converted into HTML attributes.
     * Unlike other input objects the `val` property will be specifically
     * ignored.
     *
     * buildData The data to build a file input with.
     * @param \UIM\View\Form\IContext formContext The current form context.
     * return HTML elements.
     * /
    override string render(Json[string] renderData, IContext formContext) {
        auto mergedData = renderData.merge(formContext.data);

        mergedData.remove("val");

        return _stringContents.format("file", [
            "name": mergedData["name"],
            "templateVars": mergedData["templateVars"],
            "attrs": _stringContents.formatAttributes(
                mergedData, ["name"]
            ),
        ]);
    } */
}
mixin(WidgetCalls!("File"));
