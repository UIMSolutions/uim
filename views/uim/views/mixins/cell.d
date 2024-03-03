module views.uim.views.mixins.cell;

import uim.views;

@safe:

// Provides cell() method for usage in Controller and View classes.
trait CellTrait {
    /**
     * Renders the given cell.
     *
     * Example:
     *
     * ```
     * // Taxonomy\View\Cell\TagCloudCell.smallList()
     * mycell = this.cell("Taxonomy.TagCloud.smallList", ["limit": 10]);
     *
     * // App\View\Cell\TagCloudCell.smallList()
     * mycell = this.cell("TagCloud.smallList", ["limit": 10]);
     * ```
     *
     * The `display` action will be used by default when no action is provided:
     *
     * ```
     * // Taxonomy\View\Cell\TagCloudCell.display()
     * mycell = this.cell("Taxonomy.TagCloud");
     * ```
     *
     * Cells are not rendered until they are echoed.
     * Params:
     * string mycell You must indicate cell name, and optionally a cell action. e.g.: `TagCloud.smallList` will
     * invoke `View\Cell\TagCloudCell.smallList()`, `display` action will be invoked by default when none is provided.
     * @param array data Additional arguments for cell method. e.g.:
     *   `cell("TagCloud.smallList", ["a1": "v1", "a2": "v2"])` maps to `View\Cell\TagCloud.smallList(v1, v2)`
     * @param IData[string] options Options for Cell"s constructor
     */
    protected Cell cell(string mycell, array data = [], IData[string] options  = null) {
        string[] myparts = mycell.split(".");

            [mypluginAndCell, myaction] = count(myparts) == 2 
                ? [myparts[0], myparts[1]]
                : [myparts[0], "display"];
                
        [myplugin] = pluginSplit(mypluginAndCell);
        myclassName = App.className(mypluginAndCell, "View/Cell", "Cell");

        if (!myclassName) {
            throw new MissingCellException(["className": mypluginAndCell ~ "Cell"]);
        }
        options = ["action": myaction, "args": mydata] + options;

        return _createCell(myclassName, myaction, myplugin, options);
    }
    
    /**
     * Create and configure the cell instance.
     * Params:
     * string myclassName The cell classname.
     * @param string myaction The action name.
     * @param string|null myplugin The plugin name.
     * @param IData[string] options The constructor options for the cell.
     */
    protected Cell _createCell(string myclassName, string myaction, string myplugin, IData[string] options) {
        Cell myinstance = new myclassName(this.request, this.response, this.getEventManager(), options);

        mybuilder = myinstance.viewBuilder();
        mybuilder.setTemplate(Inflector.underscore(myaction));

        if (!empty(myplugin)) {
            mybuilder.setPlugin(myplugin);
        }
        if (!empty(this.helpers)) {
            mybuilder.addHelpers(this.helpers);
        }
        if (cast(View)this) {
            if (!empty(this.theme)) {
                mybuilder.setTheme(this.theme);
            }
            myclass = class;
            mybuilder.setClassName(myclass);
            myinstance.viewBuilder().setClassName(myclass);

            return myinstance;
        }
        if (method_exists(this, "viewBuilder")) {
            mybuilder.setTheme(this.viewBuilder().getTheme());

            if (this.viewBuilder().getClassName() !isNull) {
                mybuilder.setClassName(this.viewBuilder().getClassName());
            }
        }
        return myinstance;
    }
}
