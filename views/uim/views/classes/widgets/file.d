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

    // Data defaults.
    protected IData[string] _defaultData = [
        "name": StringData (""),
        "escape": BooleanData(true),
        "templateVars": [],
    ];

    /**
     * Render a file upload form widget.
     *
     * Data supports the following keys:
     *
     * - `name` - Set the input name.
     * - `escape` - Set to false to disable HTML escaping.
     *
     * All other keys will be converted into HTML attributes.
     * Unlike other input objects the `val` property will be specifically
     * ignored.
     *
     * buildData The data to build a file input with.
     * @param \UIM\View\Form\IContext formContext The current form context.
     * return HTML elements.
     * /
    string render(IData[string] renderData, IContext formContext) {
        buildData += this.mergeDefaults(buildData, formContext);

        buildData.remove("val");

        return _stringTemplate.format("file", [
            "name": buildData["name"],
            "templateVars": buildData["templateVars"],
            "attrs": _stringTemplate.formatAttributes(
                buildData,
                ["name"]
            ),
        ]);
    } */
}
mixin(WidgetCalls!("File"));
