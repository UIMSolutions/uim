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

        configuration
            .setDefaults("name", "") // `name` - Set the input name.
            .setDefaults("escape", true) // `escape` - Set to false to disable HTML escaping.
            .setDefaults("templateVars", Json.emptyArray);

        return true;
    }

    /**
     * Render a file upload form widget.
     *
     * Data supports the following keys:
     *
     * All other keys will be converted into HTML attributes.
     * Unlike other input objects the `val` property will be specifically
     * ignored.
     */
    override string render(Json[string] renderData, IContext formContext) {
        renderData.merge(formContext.data);
        renderData.remove("val");

        /* return _stringContents.format("file", 
            renderData.data(["name", "templateVars"])
                .setPath(["attrs": _stringContents.formatAttributes(renderData, ["name"])]);  */
        return null; 
    }
}
mixin(WidgetCalls!("File"));
