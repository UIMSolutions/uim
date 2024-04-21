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
        "templateVars": ArrayData,
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
    override string render(IData[string] renderData, IContext formContext) {
        buildData = buildData.merge // Todo  this.mergeDefaults(buildData, formContext);

        buildData.remove("val");

        return _stringContents.format("file", [
            "name": buildData["name"],
            "templateVars": buildData["templateVars"],
            "attrs": _stringContents.formatAttributes(
                buildData,
                ["name"]
            ),
        ]);
    } */
}
mixin(WidgetCalls!("File"));
