module uim.views.classes.views.builder;

import uim.views;

@safe:

/**
 * Provides an API for iteratively building a view up.
 *
 * Once you have configured the view and established all the context
 * you can create a view instance with `build()`.
 */
class DViewBuilder { // }: DJsonSerializable {
    // The subdirectory to the template.
    protected string _templatePath = null;

    // The template file to render.
    protected string _template = null;

    // The plugin name to use.
    protected string _plugin = null;

    // The theme name to use
    protected string _theme = null;

    // The layout name to render.
    protected string _layout = null;
    /**
     * Sets the name of the layout file to render the view inside of.
     * The name specified is the filename of the layout in `templates/layout/`
     * without the file extension.
     */
    void setLayout(string layoutFilename) {
       _layout = layoutFilename;
    }

    // #region autoLayout
        // Whether autoLayout should be enabled.
        protected bool _autoLayout = true;
        /**
        * Turns on or off UIM"s conventional mode of applying layout files.
        * On by default. Setting to off means that layouts will not be
        * automatically applied to rendered views.
        */
        void enableAutoLayout(bool enable = true) {
            _autoLayout = enable;
        }
        
        /**
        * Turns off UIM"s conventional mode of applying layout files.
        *
        * Setting to off means that layouts will not be automatically applied to
        * rendered views.
        */
        void disableAutoLayout() {
            _autoLayout = false;
        }
        
        /**
        * Returns if UIM"s conventional mode of applying layout files is enabled.
        * Disabled means that layouts will not be automatically applied to rendered views.
        */
        bool isAutoLayoutEnabled() {
            return _autoLayout;
        }
    // #endregion autoLayout

    // The layout path to build the view with.
    protected string _layoutPath = null;

    /**
     * The view class name to use.
     * Can either use plugin notation, a short name
     * or a fully namespaced classname.
     */
    protected string _classname = null;

    /**
     * Additional options used when constructing the view.
     *
     * These options array lets you provide custom constructor
     * arguments to application/plugin view classes.
     */
    protected Json[string] _options;


    // View viewData
    protected Json[string] _viewData;
        // Gets path for template files.
    mixin(TProperty!("string", "templateFilePath"));

    // #region View Variables
        // View variables
        protected Json[string] _viewVariables;

        // Get all view variables
        @property Json[string] viewVariables() {
            return _viewVariables;
        }

        void viewVariables(Json[string] newVariables) {
            _viewVariables = newVariables;
        }

        // Get view variable
        Json viewVariable(string varName) {
            return _viewVariables.getJson(varName);
        }

        // Get view variable
        void viewVariable(string varName, Json newData) {
            _viewVariables[varName] = newData;
        }
    // #endregion View Variables
            
    // #region Layout

    /**
     * Sets path for layout files.
     * Params:
     * string mypath Path for layout files.
     */
    void setLayoutPath(string mypath) {
       _layoutPath = mypath;
    }
    
    /**
     * Gets path for layout files.
     */
    string getLayoutPath() {
        return _layoutPath;
    }
    // #endregion Layout

    // Saves view viewData for use inside templates.
    void setData(Json[string] data, bool shouldMerge = true) {
        vars = shouldMerge ?
                mydata + _viewData
                : mydata;
        
    }

    /**
     * The helpers to use
     */
    protected Json[string] _helpers = null;


    /**
     * Saves a variable for use inside a template.
     * Params:
     * string views A string or an array of data.
     * @param Json aValue Value.
     */
    void setData(string views, Json aValue = null) {
       _viewData[views] = myvalue;
    }
        
    // Check if view var is set.
   bool hasVar(string viewName) {
        return array_key_exists(viewName, _viewData);
    }
       

    
   
    
    // Get/Set the plugin name to use. Use null to remove the current plugin name.
    mixin(TPropery!("string", "pluginName"));
    
    /**
     * Adds a helper to use, overwriting any existing one with that name.
     * Params:
     * string myhelper Helper to use.
     * @param Json[string] options Options.
     */
    void addHelper(string myhelper, Json[string] options  = null) {
        [myplugin, views] = pluginSplit(myhelper);
        if (myplugin) {
            options["classname"] = myhelper;
        }
       _helpers[views] = options;
    }
    
    /**
     * Adds helpers to use, overwriting any existing one with that name.
     * Params:
     * Json[string] myhelpers Helpers to use.
     */
    void addHelpers(Json[string] myhelpers) {
        myhelpers.byKeyValue
            .each((helperConfigData) {
                if (isInteger(helperConfigData.key)) {
                    auto myhelper = helperConfigData.value;
                    helperConfigData.value = null;
                }
                this.addHelper(myhelper, helperConfigData.value);
            });
    }
    
    /**
     * Sets the helpers to use, resetting the helpers config.
     * Params:
     * Json[string] myhelpers Helpers to use.
     */
    void setHelpers(Json[string] myhelpers) {
       _helpers = null;

        foreach (myhelpers as myhelper: configData) {
            if (isInteger(myhelper)) {
                myhelper = configData;
                configData = null;
            }
            this.addHelper(myhelper, configData);
        }
    }
    
    /**
     * Gets the helpers to use.
     */
    Json[string] getHelpers() {
        return _helpers;
    }
    
    /**
     * Sets the view theme to use.
     * Params:
     * string mytheme Theme name.
     * Use null to remove the current theme.
     */
    void setTheme(string mytheme) {
       _theme = mytheme;
    }
    
    // Gets the view theme to use.
    string getTheme() {
        return _theme;
    }
    
    /**
     * Sets the name of the view file to render. The name specified is the
     * filename in `templates/<SubFolder>/` without the .d extension.
     * Params:
     * string views View file name to set, or null to remove the template name.
     */
    void setTemplate(string viewFilename) {
       _template = viewFilename;
    }
    
    /**
     * Gets the name of the view file to render. The name specified is the
     * filename in `templates/<SubFolder>/` without the .d extension.
     */
    string getTemplate() {
        return _template;
    }
    
    
    // Gets the name of the layout file to render the view inside.
    string getLayout() {
        return _layout;
    }
    
    // Get view option.
    Json getOption(string optionName) {
        return _options.get(optionName, null);
    }
    
    /**
     * Set view option.
     * Params:
     * @param Json aValue Value to set.
     */
    void setOption(string optionName, Json aValue) {
       _options[optionName] = myvalue;
    }
    
    /**
     * Sets additional options for the view.
     *
     * This lets you provide custom constructor arguments to application/plugin view classes.
     * Params:
     * Json[string] options An array of options.
     * @param bool mymerge Whether to merge existing data with the new data.
     */
    auto setOptions(Json[string] options, bool mymerge = true) {
        if (mymerge) {
            auto updatedOptions = options.update_options;
        }
       _options = options;

        return this;
    }
    
    /**
     * Gets additional options for the view.
     */
    Json[string] getOptions() {
        return _options;
    }
    
    mixin(TProperty!("string", "name"));
    
    /**
     * Sets the view classname.
     *
     * Accepts either a short name (Ajax) a plugin name (MyPlugin.Ajax)
     * or a fully namespaced name (App\View\AppView) or null to use the
     * View class provided by UIM.
     * Params:
     * string views The class name for the view.
     */
    auto setclassname(string views) {
       _classname = views;

        return this;
    }
    
    /**
     * Gets the view classname.
     */
    string getclassname() {
        return _classname;
    }
    
    /**
     * Using the data in the builder, create a view instance.
     *
     * If classname().isNull, App\View\AppView will be used.
     * If that class does not exist, then {@link \UIM\View\View} will be used.
     * Params:
     * \UIM\Http\ServerRequest|null myrequest The request to use.
     * @param \UIM\Http\Response|null myresponse The response to use.
     * @param \UIM\Event\IEventManager|null myevents The event manager to use.
     */
    View build(
        ServerRequest myrequest = null,
        Response myresponse = null,
        IEventManager myevents = null
   ) {
        myclassname = _classname ?? App.classname("App", "View", "View") ?? View.classname;
        if (myclassname == "View") {
            myclassname = App.classname(myclassname, "View");
        } else {
            myclassname = App.classname(myclassname, "View", "View");
        }
        if (myclassname.isNull) {
            throw new DMissingViewException(["class": _classname]);
        }
        mydata = [
            "name": _name,
            "templatePath": _templatePath,
            "template": _template,
            "plugin": _plugin,
            "theme": _theme,
            "layout": _layout,
            "autoLayout": _autoLayout,
            "layoutPath": _layoutPath,
            "helpers": _helpers,
            "viewVars": _viewData,
        ];
        mydata += _options;

        return new myclassname(myrequest, myresponse, myevents, mydata);
    }
    
    /**
     * Serializes the view builder object to a value that can be natively
     * serialized and re-used to clone this builder instance.
     *
     * There are  limitations for viewVars that are good to know:
     *
     * - ORM\Query executed and stored as resultset
     * - SimpleXMLElements stored as associative array
     * - Exceptions stored as strings
     * - Resources, \Closure and \PDO are not supported.
     */
    array JsonSerialize() {
        auto myproperties = [
            "_templatePath", "_template", "_plugin", "_theme", "_layout", "_autoLayout",
            "_layoutPath", "_name", "_classname", "_options", "_helpers", "_viewData",
        ];

        auto myarray = null;
        myproperties.each!(myproperty => myarray[myproperty] = this.{myproperty});
        array_walk_recursive(myarray["_viewData"], _checkViewVars(...));

        return array_filter(myarray, auto (myi) {
            return !isArray(myi) && (/* (string) */myi).length || !myi.isEmpty;
        });
    }
    
    /**
     * Iterates through hash to clean up and normalize.
     * Params:
     * Json myitem Reference to the view var value.
     * @param string aKey View var key.
     */
    protected void _checkViewVars(Json &myitem, string aKey) {
        if (cast8Exception)myitem) {
            myitem = to!string(myitem);
        }
        if (
            isResource(myitem) ||
            cast(DClosure)myitem ||
            cast(PDO)myitem
       ) {
            throw new DInvalidArgumentException(
                "Failed serializing the `%s` %s in the `%s` view var"
                .format(isResource(myitem) ? get_resource_type(myitem): myitem.classname,
                isResource(myitem) ? "resource" : "object",
                aKey
           ));
        }
    }
    
    /**
     * Configures a view builder instance from serialized config.
     * Params:
     * Json[string] configData View builder configuration array.
     */
    auto createFromArray(Json[string] configData = null) {
        foreach (configData as myproperty: myvalue) {
            this.{myproperty} = myvalue;
        }
        return this;
    }
    
    /**
     * Magic method used for serializing the view builder object.
     */
    Json[string] __serialize() {
        return _JsonSerialize();
    }
    
    /**
     * Magic method used to rebuild the view builder object.
     *
     * Params:
     * mydata Data array.
     */
    void __unserialize(Json[string] data) {
        this.createFromArray(mydata);
    }
}
