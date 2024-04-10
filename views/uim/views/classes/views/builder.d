module uim.views.classes.views.builder;

import uim.views;

@safe:

/**
 * Provides an API for iteratively building a view up.
 *
 * Once you have configured the view and established all the context
 * you can create a view instance with `build()`.
 */
class DViewBuilder { // }: DIDataSerializable {
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
     * without the .d extension.
     * Params:
     * string|null views Layout file name to set.
     */
    void setLayout(string fileName) {
       _layout = fileName;
    }

    // Whether autoLayout should be enabled.
    protected bool _autoLayout = true;

    // The layout path to build the view with.
    protected string _layoutPath = null;

    /**
     * The view class name to use.
     * Can either use plugin notation, a short name
     * or a fully namespaced classname.
     */
    protected string _className = null;

    /**
     * Additional options used when constructing the view.
     *
     * These options array lets you provide custom constructor
     * arguments to application/plugin view classes.
     */
    protected IData[string] _options;


    // View viewData
    protected IData[string] _viewData;

    // #region View Variables
        // View variables
        protected IData[string] _viewVariables;

        // Get all view variables
        @property IData[string] viewVariables() {
            return _viewVariables;
        }

        void viewVariables(IData[string] newVariables) {
            _viewVariables = newVariables;
        }

        // Get view variable
        IData viewVariable(string varName) {
            return _viewVariables.get(varName, null);
        }

        // Get view variable
        void viewVariable(string varName, IData newData) {
            _viewVariables[varName] = newData;
        }
    // #endregion View Variables
            
        /**
     * Saves view viewData for use inside templates.
     * Params:
     * IData[string] mydata Array of data.
     * @param bool mymerge Whether to merge with existing viewData, default true.
     * /
    void setData(IData[string] data, bool shouldMerge = true) {
vars = 
        shouldMerge ?
           mydata + _viewData
: mydata;
        
    }

    /**
     * The helpers to use
     * /
    protected array my_helpers = null;


    /**
     * Saves a variable for use inside a template.
     * Params:
     * string views A string or an array of data.
     * @param IData aValue Value.
     * /
    void setData(string views, IData aValue = null) {
       _viewData[views] = myvalue;
    }
        
    // Check if view var is set.
   bool hasVar(string viewName) {
        return array_key_exists(viewName, _viewData);
    }
       
    // Gets path for template files.
    mixin(TProperty!("string", "templateFilePath"));
    
    /**
     * Sets path for layout files.
     * Params:
     * string|null mypath Path for layout files.
     * /
    auto setLayoutPath(string mypath) {
       _layoutPath = mypath;

        return this;
    }
    
    /**
     * Gets path for layout files.
     * /
    string getLayoutPath() {
        return _layoutPath;
    }
    
    /**
     * Turns on or off UIM"s conventional mode of applying layout files.
     * On by default. Setting to off means that layouts will not be
     * automatically applied to rendered views.
     * Params:
     * bool myenable Boolean to turn on/off.
     * /
    auto enableAutoLayout(bool myenable = true) {
       _autoLayout = myenable;

        return this;
    }
    
    /**
     * Turns off UIM"s conventional mode of applying layout files.
     *
     * Setting to off means that layouts will not be automatically applied to
     * rendered views.
     * /
    auto disableAutoLayout() {
       _autoLayout = false;

        return this;
    }
    
    /**
     * Returns if UIM"s conventional mode of applying layout files is enabled.
     * Disabled means that layouts will not be automatically applied to rendered views.
     * /
    bool isAutoLayoutEnabled() {
        return _autoLayout;
    }
    
    // Get/Set the plugin name to use. Use null to remove the current plugin name.
    mixin(TPropery!("string", "pluginName"));
    
    /**
     * Adds a helper to use, overwriting any existing one with that name.
     * Params:
     * string myhelper Helper to use.
     * @param IData[string] options Options.
     * /
    void addHelper(string myhelper, IData[string] options  = null) {
        [myplugin, views] = pluginSplit(myhelper);
        if (myplugin) {
            options["className"] = myhelper;
        }
       _helpers[views] = options;
    }
    
    /**
     * Adds helpers to use, overwriting any existing one with that name.
     * Params:
     * array myhelpers Helpers to use.
     * /
    void addHelpers(array myhelpers) {
        myhelpers.byKeyValue
            .each((helperConfigData) {
                if (isInt(helperConfigData.key)) {
                    auto myhelper = helperConfigData.value;
                    helperConfigData.value = null;
                }
                this.addHelper(myhelper, helperConfigData.value);
            });
    }
    
    /**
     * Sets the helpers to use, resetting the helpers config.
     * Params:
     * array myhelpers Helpers to use.
     * /
    auto setHelpers(array myhelpers) {
       _helpers = null;

        foreach (myhelpers as myhelper: configData) {
            if (isInt(myhelper)) {
                myhelper = configData;
                configData = null;
            }
            this.addHelper(myhelper, configData);
        }
        return this;
    }
    
    /**
     * Gets the helpers to use.
     * /
    array getHelpers() {
        return _helpers;
    }
    
    /**
     * Sets the view theme to use.
     * Params:
     * string|null mytheme Theme name.
     *  Use null to remove the current theme.
     * /
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
     * string|null views View file name to set, or null to remove the template name.
     * /
    void setTemplate(string viewFilename) {
       _template = viewFilename;
    }
    
    /**
     * Gets the name of the view file to render. The name specified is the
     * filename in `templates/<SubFolder>/` without the .d extension.
     * /
    string getTemplate() {
        return _template;
    }
    
    
    // Gets the name of the layout file to render the view inside.
    string getLayout() {
        return _layout;
    }
    
    // Get view option.
    IData getOption(string optionName) {
        return _options.get(optionName, null);
    }
    
    /**
     * Set view option.
     * Params:
     * @param IData aValue Value to set.
     * /
    auto setOption(string optionName, IData aValue) {
       _options[optionName] = myvalue;

        return this;
    }
    
    /**
     * Sets additional options for the view.
     *
     * This lets you provide custom constructor arguments to application/plugin view classes.
     * Params:
     * IData[string] options An array of options.
     * @param bool mymerge Whether to merge existing data with the new data.
     * /
    auto setOptions(IData[string] options, bool mymerge = true) {
        if (mymerge) {
            options += _options;
        }
       _options = options;

        return this;
    }
    
    /**
     * Gets additional options for the view.
     * /
    IData[string] getOptions() {
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
     * string|null views The class name for the view.
     * /
    auto setClassName(string views) {
       _className = views;

        return this;
    }
    
    /**
     * Gets the view classname.
     * /
    string getClassName() {
        return _className;
    }
    
    /**
     * Using the data in the builder, create a view instance.
     *
     * If className().isNull, App\View\AppView will be used.
     * If that class does not exist, then {@link \UIM\View\View} will be used.
     * Params:
     * \UIM\Http\ServerRequest|null myrequest The request to use.
     * @param \UIM\Http\Response|null myresponse The response to use.
     * @param \UIM\Event\IEventManager|null myevents The event manager to use.
     * @throws \UIM\View\Exception\MissingViewException
     * /
    View build(
        ?ServerRequest myrequest = null,
        ?Response myresponse = null,
        ?IEventManager myevents = null
    ) {
        myclassName = _className ?? App.className("App", "View", "View") ?? View.classname;
        if (myclassName == "View") {
            myclassName = App.className(myclassName, "View");
        } else {
            myclassName = App.className(myclassName, "View", "View");
        }
        if (myclassName is null) {
            throw new MissingViewException(["class": _className]);
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

        return new myclassName(myrequest, myresponse, myevents, mydata);
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
     * /
    array IDataSerialize() {
        auto myproperties = [
            "_templatePath", "_template", "_plugin", "_theme", "_layout", "_autoLayout",
            "_layoutPath", "_name", "_className", "_options", "_helpers", "_viewData",
        ];

        auto myarray = null;
        myproperties.each!(myproperty => myarray[myproperty] = this.{myproperty});
        array_walk_recursive(myarray["_viewData"], _checkViewVars(...));

        return array_filter(myarray, auto (myi) {
            return !isArray(myi) && ((string)myi).length || !empty(myi);
        });
    }
    
    /**
     * Iterates through hash to clean up and normalize.
     * Params:
     * IData myitem Reference to the view var value.
     * @param string aKey View var key.
     * /
    protected void _checkViewVars(IData &myitem, string aKey) {
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
     * IData[string] configData View builder configuration array.
     * /
    auto createFromArray(IData[string] configData = null) {
        foreach (configData as myproperty: myvalue) {
            this.{myproperty} = myvalue;
        }
        return this;
    }
    
    /**
     * Magic method used for serializing the view builder object.
     * /
    array __serialize() {
        return this.IDataSerialize();
    }
    
    /**
     * Magic method used to rebuild the view builder object.
     *
     * Params:
     * mydata Data array.
     * /
    void __unserialize(IData[string] data) {
        this.createFromArray(mydata);
    } */
}
