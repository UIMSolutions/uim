module uim.views.widgets;

import uim.views;

@safe:

/**
 * Input widget class for generating a file upload control.
 *
 * This class is usually used internally by `UIM\View\Helper\FormHelper`,
 * it but can be used to generate standalone file upload controls.
 */
class FileWidget : DWidget {
    // Data defaults.
    protected IData[string] _defaultData = [
        "name": "",
        "escape": true,
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
     */
    string render(IData[string] renderData, IContext formContext) {
        buildData += this.mergeDefaults(buildData, formContext);

        unset(buildData["val"]);

        return _templates.format("file", [
            "name": buildData["name"],
            "templateVars": buildData["templateVars"],
            "attrs": _templates.formatAttributes(
                buildData,
                ["name"]
            ),
        ]);
    }
}
