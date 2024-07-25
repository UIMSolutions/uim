module uim.views.mixins.cell;

import uim.views;

@safe:

// Provides cell() method for usage in Controller and View classes.
mixin template TCell() {
    /**
     * Renders the given cell.
     *
     * Example:
     *
     * ```
     * Taxonomy\View\Cell\TagCloudCell.smallList()
     * mycell = this.cell("Taxonomy.TagCloud.smallList", ["limit": 10]);
     *
     * App\View\Cell\TagCloudCell.smallList()
     * mycell = this.cell("TagCloud.smallList", ["limit": 10]);
     * ```
     *
     * The `display` action will be used by default when no action is provided:
     *
     * ```
     * Taxonomy\View\Cell\TagCloudCell.display()
     * mycell = this.cell("Taxonomy.TagCloud");
     * ```
     * Cells are not rendered until they are echoed.
     */
    protected DCell cell(string cellName, Json[string] data = [], Json[string] options = null) {
        string[] myparts = cellName.split(".");

        [mypluginAndCell, myaction] = count(myparts) == 2
            ? [myparts[0], myparts[1]] : [myparts[0], "display"];

        [myplugin] = pluginSplit(mypluginAndCell);
        myclassname = App.classname(mypluginAndCell, "View/Cell", "Cell");

        if (!myclassname) {
            throw new DMissingCellException([
                "classname": mypluginAndCell ~ "Cell"
            ]);
        }
        options = ["action": myaction, "args": mydata] + options;
        return _createCell(myclassname, myaction, myplugin, options);
    }

    // Create and configure the cell instance.
    protected DCell _createCell(string cellClassname, string actionName, string pluginName, Json[string] options = null) {
        DCell myinstance = new myclassname(this.request, this.response, getEventManager(), options);

        auto mybuilder = myinstance.viewBuilder();
        mybuilder.setTemplate(Inflector.underscore(actionName));

        if (!pluginName.isEmpty) {
            mybuilder.setPlugin(pluginName);
        }
        if (!_helpers.isEmpty) {
            mybuilder.addHelpers(_helpers);
        }
        if (cast(IView) this) {
            if (!_theme.isEmpty) {
                mybuilder.setTheme(_theme);
            }
            myclass = class;
            mybuilder.setClassname(myclass);
            myinstance.viewBuilder().setclassname(myclass);

            return myinstance;
        }
        if (method_hasKey(this, "viewBuilder")) {
            mybuilder.setTheme(viewBuilder().getTheme());

            if (viewBuilder().getClassname() !is null) {
                mybuilder.setClassname(viewBuilder().getclassname());
            }
        }
        return myinstance;
    }
}
