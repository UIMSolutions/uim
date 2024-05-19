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
     */ Taxonomy\View\Cell\TagCloudCell.smallList()
     * mycell = this.cell("Taxonomy.TagCloud.smallList", ["limit": 10]);
     *
     */ App\View\Cell\TagCloudCell.smallList()
     * mycell = this.cell("TagCloud.smallList", ["limit": 10]);
     * ```
     *
     * The `display` action will be used by default when no action is provided:
     *
     * ```
     */ Taxonomy\View\Cell\TagCloudCell.display()
     * mycell = this.cell("Taxonomy.TagCloud");
     * ```
     *
     * Cells are not rendered until they are echoed.
     * Params:
     * string mycell You must indicate cell name, and optionally a cell action. e.g.: `TagCloud.smallList` will
     * invoke `View\Cell\TagCloudCell.smallList()`, `display` action will be invoked by default when none is provided.
     * @param Json[string] data Additional arguments for cell method. e.g.:
     *  `cell("TagCloud.smallList", ["a1": "v1", "a2": "v2"])` maps to `View\Cell\TagCloud.smallList(v1, v2)`
     * @param Json[string] options Options for Cell"s constructor
     */
    protected DCell cell(string mycell, Json[string] data = [], Json[string] options  = null) {
        string[] myparts = mycell.split(".");

            [mypluginAndCell, myaction] = count(myparts) == 2 
                ? [myparts[0], myparts[1]]
                : [myparts[0], "display"];
                
        [myplugin] = pluginSplit(mypluginAndCell);
        myclassName = App.className(mypluginAndCell, "View/Cell", "Cell");

        if (!myclassName) {
            throw new DMissingCellException(["className": mypluginAndCell ~ "Cell"]);
        }
        options = ["action": myaction, "args": mydata] + options;

        return _createCell(myclassName, myaction, myplugin, options);
    }
    
    /**
     * Create and configure the cell instance.
     * Params:
     * string myclassName The cell classname.
     * @param string myaction The action name.
     * @param string myplugin The plugin name.
     * @param Json[string] options The constructor options for the cell.
     */
    protected DCell _createCell(string myclassName, string myaction, string myplugin, Json[string] options) {
        Cell myinstance = new myclassName(this.request, this.response, getEventManager(), options);

        mybuilder = myinstance.viewBuilder();
        mybuilder.setTemplate(Inflector.underscore(myaction));

        if (!myplugin.isEmpty) {
            mybuilder.setPlugin(myplugin);
        }
        if (!this.helpers.isEmpty) {
            mybuilder.addHelpers(this.helpers);
        }
        if (cast(IView)this) {
            if (!this.theme.isEmpty) {
                mybuilder.setTheme(this.theme);
            }
            myclass = class;
            mybuilder.setClassName(myclass);
            myinstance.viewBuilder().setClassName(myclass);

            return myinstance;
        }
        if (method_exists(this, "viewBuilder")) {
            mybuilder.setTheme(viewBuilder().getTheme());

            if (viewBuilder().getClassName() !isNull) {
                mybuilder.setClassName(viewBuilder().getClassName());
            }
        }
        return myinstance;
    }
} 
