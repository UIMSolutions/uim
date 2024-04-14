module uim.views.classes.views.view;

import uim.views;

@safe:

/**
 * View, the V in the MVC triad. View interacts with Helpers and view variables passed
 * in from the controller to render the results of the controller action. Often this is HTML,
 * but can also take the form of IData, XML, PDF"s or streaming files.
 *
 * UIM uses a two-step-view pattern. This means that the template content is rendered first,
 * and then inserted into the selected layout. This also means you can pass data from the template to the
 * layout using `this.set()`
 *
 * View class supports using plugins as themes. You can set
 *
 * ```
 * auto beforeRender(\UIM\Event\IEvent myevent)
 * {
 *     this.viewBuilder().setTheme("SuperHot");
 * }
 * ```
 *
 * in your Controller to use plugin `SuperHot` as a theme. Eg. If current action
 * is PostsController.index() then View class will look for template file
 * `plugins/SuperHot/templates/Posts/index.d`. If a theme template
 * is not found for the current action the default app template file is used.
 *
 * @property \UIM\View\Helper\BreadcrumbsHelper myBreadcrumbs
 * @property \UIM\View\Helper\FlashHelper myFlash
 * @property \UIM\View\Helper\FormHelper myForm
 * @property \UIM\View\Helper\HtmlHelper myHtml
 * @property \UIM\View\Helper\NumberHelper myNumber
 * @property \UIM\View\Helper\PaginatorHelper myPaginator
 * @property \UIM\View\Helper\TextHelper myText
 * @property \UIM\View\Helper\TimeHelper myTime
 * @property \UIM\View\Helper\UrlHelper myUrl
 * @property \UIM\View\ViewBlock myBlocks
 * @implements \UIM\Event\IEventDispatcher<\UIM\View\View>
 */
class DView : IView { //  }: IEventDispatcher {
    mixin TConfigurable;
    // @use \UIM\Event\EventDispatcherTrait<\UIM\View\View>
    mixin TEventDispatcher;
    mixin TLog;

    this() {
        initialize;
    }

    this(IData[string] initData) {
        initialize(initData);
    }

    this(string newName) {
        this();
        this.name(newName);
    }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    // The name of the plugin.
    mixin(TProperty!("string", "plugin"));

    // Name of the controller that created the View if any.
    protected string _viewControllerName = "";

    // Retrieve the current template type
    protected string _currentType;
    @property string currentType() {
        return _currentType;
    }

    // File extension. Defaults to ".d".
    protected string _ext = ".d";

    /* 
    use CellTemplate() {
        cell as public;
    }
    
    // Helpers collection
    protected DHelperRegistry my_helpers = null;

    // ViewBlock instance.
    protected IViewBlock myBlocks;

    // A configuration array for helpers to be loaded.
    protected IData[string][string] myhelpers = null;

    // The name of the subfolder containing templates for this View.
    protected string mytemplatePath = "";

    /**
     * The name of the template file to render. The name specified
     * is the filename in `templates/<SubFolder>/` without the .d extension.
     * /
    protected string mytemplateFileName;

    /**
     * The name of the layout file to render the template inside of. The name specified
     * is the filename of the layout in `templates/layout/` without the .d
     * extension.
     * /
    protected string mylayoutName = "default";

    // The name of the layouts subfolder containing layouts for this View.
    protected string mylayoutPath = "";

    /**
     * Turns on or off UIM"s conventional mode of applying layout files. On by default.
     * Setting to off means that layouts will not be automatically applied to rendered templates.
     * /
    protected bool _autoLayout = true;

    // An array of variables
    protected IData[string] _viewVars;


    /**
     * Sub-directory for this template file. This is often used for extension based routing.
     * Eg. With an `xml` extension, mysubDir would be `xml/`
     * /
    protected string _subDir = "";

    // The view theme to use.
    protected string _viewTheme;

    /**
     * An instance of a \UIM\Http\ServerRequest object that contains information about the current request.
     * This object contains all the information about a request and several methods for reading
     * additional information about the request.
     * /
    protected IServerRequest myrequest;

    // Reference to the Response object
    protected DResponse myresponse;

    /**
     * The Cache configuration View will use to store cached elements. Changing this will change
     * the default configuration elements are stored under. You can also choose a cache config
     * per element.
     *
     * @see \UIM\View\View.element()
     * /
    protected string myelementCache = "default";

    // List of variables to collect from the associated controller.
    protected string[] my_passedVars = [
        "viewVars", "autoLayout", "helpers", "template", "layout", "name", "theme",
        "layoutPath", "templatePath", "plugin",
    ];

    // Holds an array of paths.
    protected string[] my_paths = null;

    // Holds an array of plugin paths.
    protected array<string[] my_pathsForPlugin = null;

    // The names of views and their parents used with View.extend();
    protected string[] my_parents = null;

    // The currently rendering view file. Used for resolving parent files.
    protected string my_current = "";

    /**
     * Currently rendering an element. Used for finding parent fragments
     * for elements.
     * /
    protected string my_currentType = "";

    // Content stack, used for nested templates that all use View.extend();
    protected string[] my_stack;

    // ViewBlock class.
    protected string my_viewBlockClass = ViewBlock.classname;

    // Constant for view file type "template".
    const string TYPE_TEMPLATE = "template";

    // Constant for view file type "element"
    const string TYPE_ELEMENT = "element";

    // Constant for view file type "layout"
    const string TYPE_LAYOUT = "layout";

    // Constant for type used for App.path().
    const string NAME_TEMPLATE = "templates";

    // Constant for folder name containing files for overriding plugin templates.
    const string PLUGIN_TEMPLATE_FOLDER = "plugin";

    /**
     * The magic "match-all" content type that views can use to
     * behave as a fallback during content-type negotiation.
     * /
    const string TYPE_MATCH_ALL = "_match_all_";

    /**
     * Constructor
     * Params:
     * \UIM\Http\ServerRequest|null myrequest Request instance.
     * @param \UIM\Http\Response|null myresponse Response instance.
     * @param \UIM\Event\IEventManager|null myeventManager Event manager instance.
     * @param IData[string] myviewOptions View options. See {@link View.my_passedVars} for list of
     *  options which get set as class properties.
     * /
    this(
        ?ServerRequest myrequest = null,
        ?Response myresponse = null,
        ?IEventManager myeventManager = null,
        array myviewOptions = []
    ) {
        if (!myeventManager is null) {
            // Set the event manager before accessing the helper registry below
            // to ensure that helpers are registered as listeners with the manager when loaded.
            this.setEventManager(myeventManager);
        }
        foreach (myvar; _passedVars) {
            if (isSet(myviewOptions[myvar])) {
                this.{myvar} = myviewOptions[myvar];
            }
        }
        if (this.helpers) {
            this.helpers = this.helpers().normalizeArray(this.helpers);
        }
        configuration.update(array_diff_key(
            myviewOptions,
            array_flip(_passedVars)
        ));

        myrequest ??= Router.getRequest() ?: new DServerRequest(["base": "", "url": "", "webroot": "/"]);
        this.request = myrequest;
        this.response = myresponse ?: new DResponse();
        this.Blocks = new _viewBlockClass();
        this.initialize();
        this.loadHelpers();
    }
    
    /**
     * Initialization hook method.
     *
     * Properties like myhelpers etc. cannot be initialized statically in your custom
     * view class DAs they are overwritten by values from controller in constructor.
     * So this method allows you to manipulate them as required after view instance
     * is constructed.
     *
     * Helpers can be added using {@link addHelper()} method.
     * /
    bool initialize(IData[string] myConfiguration = null) {
       
    }

    // Set the response content-type based on the view"s contentType()
    protected void setContentType() {
        myviewContentType = this.contentType();
        if (!myviewContentType || myviewContentType == TYPE_MATCH_ALL) {
            return;
        }
        myresponse = this.getResponse();
        auto myresponseType = myresponse.getHeaderLine("Content-Type");
        if (myresponseType.isEmpty || myresponseType.startsWith("text/html")) {
            myresponse = myresponse.withType(myviewContentType);
        }
        this.setResponse(myresponse);
    }

    // Mime-type this view class renders as.
    static string contentType() {
        return "";
    }

    // Gets the request instance.
    ServerRequest getRequest() {
        return this.request;
    }

    /**
     * Sets the request objects and configures a number of controller properties
     * based on the contents of the request. The properties that get set are:
     *
     * - this.request - To the myrequest parameter
     * - this.plugin - To the value returned by myrequest.getParam("plugin")
     * Params:
     * \UIM\Http\ServerRequest myrequest Request instance.
     * /
    void setRequest(ServerRequest myrequest) {
        this.request = myrequest;
        this.plugin = myrequest.getParam("plugin");
    }

    // Gets the response instance.
    Response getResponse() {
        return this.response;
    }
    
    // Sets the response instance.
    auto setResponse(Response myresponse) {
        this.response = myresponse;

        return this;
    }

    // Get path for templates files.
    string getTemplatePath() {
        return this.templatePath;
    }

    // Set path for templates files.
    auto setTemplatePath(string mypath) {
        this.templatePath = mypath;

        return this;
    }

    // Get path for layout files.
    string getLayoutPath() {
        return this.layoutPath;
    }

    // Set path for layout files.
    void  setLayoutPath(string path) {
        this.layoutPath = path;
    }
    
    /**
     * Returns if UIM"s conventional mode of applying layout files is enabled.
     * Disabled means that layouts will not be automatically applied to rendered views.
     * /
    bool isAutoLayoutEnabled() {
        return this.autoLayout;
    }
    
    /**
     * Turns on or off UIM"s conventional mode of applying layout files.
     * On by default. Setting to off means that layouts will not be
     * automatically applied to rendered views.
     * Params:
     * bool myenable Boolean to turn on/off.
     * /
    auto enableAutoLayout(bool myenable = true) {
        this.autoLayout = myenable;

        return this;
    }

    /**
     * Turns off UIM"s conventional mode of applying layout files.
     * Layouts will not be automatically applied to rendered views.
     * /
    auto disableAutoLayout() {
        this.autoLayout = false;

        return this;
    }
    
    // Get the current view theme.
    string getTheme() {
        return this.theme;
    }

    /**
     * Set the view theme to use.
     * Params:
     * string|null mytheme Theme name.
     * /
    auto setTheme(string mytheme) {
        this.theme = mytheme;

        return this;
    }

    /**
     * Get the name of the template file to render. The name specified is the
     * filename in `templates/<SubFolder>/` without the .d extension.
     * /
    string getTemplate() {
        return this.template;
    }

    /**
     * Set the name of the template file to render. The name specified is the
     * filename in `templates/<SubFolder>/` without the .d extension.
     * Params:
     * string views Template file name to set.
     * /
    void setTemplate(string views) {
        this.template = views;
    }

    /**
     * Get the name of the layout file to render the template inside of.
     * The name specified is the filename of the layout in `templates/layout/`
     * without the .d extension.
     * /
    string getLayout() {
        return this.layout;
    }

    /**
     * Set the name of the layout file to render the template inside of.
     * The name specified is the filename of the layout in `templates/layout/`
     * without the .d extension.
     * Params:
     * string views Layout file name to set.
     * /
    auto setLayout(string fileName) {
        this.layout = fileName;

        return this;
    }

    /**
     * Renders a piece of PHP with provided parameters and returns HTML, XML, or any other string.
     *
     * This realizes the concept of Elements, (or "partial layouts") and the myparams array is used to send
     * data to be used in the element. Elements can be cached improving performance by using the `cache` option.
     * Params:
     * string templatefilename Name of template file in the `templates/element/` folder,
     *  or `_plugin.template` to use the template element from _plugin. If the element
     *  is not found in the plugin, the normal view path cascade will be searched.
     * @param array data Array of data to be made available to the rendered view (i.e. the Element)
     * @param IData[string] options Array of options. Possible keys are:
     *
     * - `cache` - Can either be `true`, to enable caching using the config in View.myelementCache. Or an array
     *  If an array, the following keys can be used:
     *
     *  - `config` - Used to store the cached element in a custom cache configuration.
     *  - `key` - Used to define the key used in the Cache.write(). It will be prefixed with `element_`
     *
     * - `callbacks` - Set to true to fire beforeRender and afterRender helper callbacks for this element.
     *  Defaults to false.
     * - `ignoreMissing` - Used to allow missing elements. Set to true to not throw exceptions.
     * - `plugin` - setting to false will force to use the application"s element from plugin templates, when the
     *  plugin has element with same name. Defaults to true
     * /
    string element(string templatefilename, array data = [], IData[string] options  = null) {
        options = options.update["callbacks": BooleanData(false), "cache": null, "plugin": null, "ignoreMissing": BooleanData(false)];
        if (isSet(options["cache"])) {
            options["cache"] = _elementCache(
                templatefilename,
                mydata,
                array_diff_key(options, ["callbacks": BooleanData(false), "plugin": null, "ignoreMissing": null])
            );
        }

        bool _pluginCheck = options["plugin"] != false;
        auto filepath = _getElementFileName(templatefilename, _pluginCheck);
        if (filepath && options["cache"]) {
            return this.cache(void () use (filepath, mydata, options) {
                writeln(_renderElement(filepath, mydata, options);
            }, options["cache"]);
        }
        if (filepath) {
            return _renderElement(filepath, mydata, options);
        }
        if (options["ignoreMissing"]) {
            return "";
        }
        [_plugin, myelementName] = this.pluginSplit(templatefilename, _pluginCheck);
        auto mypaths = iterator_to_array(this.getElementPaths(_plugin));
        throw new MissingElementException([templatefilename ~ _ext, myelementName ~ _ext], mypaths);
    }

    /**
     * Create a cached block of view logic.
     *
     * This allows you to cache a block of view output into the cache
     * defined in `elementCache`.
     *
     * This method will attempt to read the cache first. If the cache
     * is empty, the myblock will be run and the output stored.
     * Params:
     * callable myblock The block of code that you want to cache the output of.
     * /
    string cache(callable myblock, IData[string] options  = null) {
        IData[string] options = options.update["key": "", "config": this.elementCache];
        if (options["key"].isEmpty) {
            throw new DInvalidArgumentException("Cannot cache content with an empty key");
        }
        result = Cache.read(options["key"], options["config"]);
        if (result) {
            return result;
        }
        mybufferLevel = ob_get_level();
        ob_start();

        try {
            myblock();
        } catch (Throwable myexception) {
            while (ob_get_level() > mybufferLevel) {
                ob_end_clean();
            }
            throw myexception;
        }
        result = to!string(ob_get_clean());

        Cache.write(options["key"], result, options["config"]);

        return result;
    }

    /**
     * Checks if an element exists
     * Params:
     * string templatefilename Name of template file in the `templates/element/` folder,
     *  or `_plugin.template` to check the template element from _plugin. If the element
     *  is not found in the plugin, the normal view path cascade will be searched.
     * /
    bool elementExists(string templatefilename) {
        return (bool)_getElementFileName(templatefilename);
    }
    
    /**
     * Renders view for given template file and layout.
     *
     * Render triggers helper callbacks, which are fired before and after the template are rendered,
     * as well as before and after the layout. The helper callbacks are called:
     *
     * - `beforeRender`
     * - `afterRender`
     * - `beforeLayout`
     * - `afterLayout`
     *
     * If View.myautoLayout is set to `false`, the template will be returned bare.
     *
     * Template and layout names can point to plugin templates or layouts. Using the `Plugin.template` syntax
     * a plugin template/layout/ can be used instead of the app ones. If the chosen plugin is not found
     * the template will be located along the regular view path cascade.
     * Params:
     * string|null mytemplate Name of template file to use
     * @param string|false|null mylayout Layout to use. False to disable.
     * /
    string render(string mytemplate = null, string|false|null mylayout = null) {
        mydefaultLayout = "";
        mydefaultAutoLayout = null;
        if (mylayout == false) {
            mydefaultAutoLayout = this.autoLayout;
            this.autoLayout = false;
        } elseif (mylayout !isNull) {
            mydefaultLayout = this.layout;
            this.layout = mylayout;
        }
        mytemplateFileName = _getTemplateFileName(mytemplate);
       _currentType = TYPE_TEMPLATE;
        this.dispatchEvent("View.beforeRender", [mytemplateFileName]);
        this.Blocks.set("content", _render(mytemplateFileName));
        this.dispatchEvent("View.afterRender", [mytemplateFileName]);

        if (this.autoLayout) {
            if (this.layout.isEmpty) {
                throw new UimException(
                    "View.mylayout must be a non-empty string." .
                    "To disable layout rendering use method `View.disableAutoLayout()` instead."
                );
            }
            this.Blocks.set("content", this.renderLayout("", this.layout));
        }
        if (mylayout !isNull) {
            this.layout = mydefaultLayout;
        }
        if (mydefaultAutoLayout !isNull) {
            this.autoLayout = mydefaultAutoLayout;
        }
        return this.Blocks.get("content");
    }
    
    /**
     * Renders a layout. Returns output from _render().
     *
     * Several variables are created for use in layout.
     * Params:
     * string mycontent Content to render in a template, wrapped by the surrounding layout.
     * @param string|null mylayout Layout name
     * /
    string renderLayout(string mycontent, string mylayout = null) {
        mylayoutFileName = _getLayoutFileName(mylayout);

        if (!empty(mycontent)) {
            this.Blocks.set("content", mycontent);
        }
        this.dispatchEvent("View.beforeLayout", [mylayoutFileName]);

        string mytitle = this.Blocks.get("title");
        if (mytitle.isEmpty) {
            mytitle = Inflector.humanize(this.templatePath.replace(DIRECTORY_SEPARATOR, "/"));
            this.Blocks.set("title", mytitle);
        }
       _currentType = TYPE_LAYOUT;
        this.Blocks.set("content", _render(mylayoutFileName));

        this.dispatchEvent("View.afterLayout", [mylayoutFileName]);

        return this.Blocks.get("content");
    }

    // Returns a list of variables available in the current View context
    string[] getVars() {
        return this.viewVars.keys;
    }
    
    /**
     * Returns the contents of the given View variable.
     * Params:
     * @param IData mydefault The default/fallback content of myvar.
     * /
    IData get(string valueName, IData defaultValue = null) {
        return this.viewVars.get(valueName, defaultValue);
    }

    /**
     * Saves a variable or an associative array of variables for use inside a template.
     * Params:
     * string[] views A string or an array of data.
     * @param IData aValue Value in case views is a string (which then works as the key).
     *  Unused if views is an associative array, otherwise serves as the values to views"s keys.
     * /
    void set(string[] views, IData aValue = null) {
        if (views.isArray) {
            if (myvalue.isArray) {
                /** @var array|false mydata Coerce phpstan to accept failure case * /
                mydata = array_combine(views, myvalue);
                if (mydata == false) {
                    throw new UimException(
                        "Invalid data provided for array_combine() to work: Both views and myvalue require same count."
                    );
                }
            } else {
                mydata = views;
            }
        } else {
            mydata = [views: myvalue];
        }
        this.viewVars = mydata + this.viewVars;
    }

    // Get the names of all the existing blocks.
    string[] blocks() {
        return _blocks.keys;
    }

    /**
     * Start capturing output for a "block"
     *
     * You can use start on a block multiple times to
     * append or prepend content in a capture mode.
     *
     * ```
     * // Append content to an existing block.
     * this.start("content");
     * writeln(this.fetch("content");
     * writeln("Some new content";
     * this.end();
     *
     * // Prepend content to an existing block
     * this.start("content");
     * writeln("Some new content";
     * writeln(this.fetch("content");
     * this.end();
     * ```
     * Params:
     * string views The name of the block to capture for.
     * /
    void start(string blockName) {
        _blocks.start(blockName);
    }

    /**
     * Append to an existing or new block.
     *
     * Appending to a new block will create the block.
     * Params:
     * string views Name of the block
     * @param IData aValue The content for the block. Value will be type cast
     *  to string.
     * /
    void append(string blockName, IData aValue = null) {
        _blocks.concat(blockName, myvalue);
    }
    
    /**
     * Prepend to an existing or new block.
     *
     * Prepending to a new block will create the block.
     * Params:
     * string views Name of the block
     * @param IData aValue The content for the block. Value will be type cast
     *  to string.
     * /
    void prepend(string blockName, IData aValue) {
        _blocks.concat(blockName, myvalue, ViewBlock.PREPEND);
    }

    /**
     * Set the content for a block. This will overwrite any
     * existing content.
     * Params:
     * @param IData aValue The content for the block. Value will be type cast
     *  to string.
     * /
    void assign(string blockName, IData aValue) {
        this.Blocks.set(blockName, myvalue);
    }

    /**
     * Reset the content for a block. This will overwrite any
     * existing content.
     * Params:
     * string views Name of the block
     * /
    void reset(string views) {
        this.assign(views, "");
    }
    
    /**
     * Fetch the content for a block. If a block is
     * empty or undefined "" will be returned.
     * /
    string fetch(string blockName, string defaultText = null) {
        return _blocks.get(blockName, defaultText);
    }

    // End a capturing block. The compliment to View.start()
    void end() {
        this.Blocks.end();
    }

    // Check if a block exists
   bool exists(string blockName) {
        return _blocks.exists(blockName);
    }

    /**
     * Provides template or element extension/inheritance. Templates can : a
     * parent template and populate blocks in the parent template.
     * Params:
     * string views The template or element to "extend" the current one with.
     * @return this
     * @throws \LogicException when you extend a template with itself or make extend loops.
     * @throws \LogicException when you extend an element which doesn"t exist
     * /
    auto extend(string views) {
        mytype = views[0] == "/" ? TYPE_TEMPLATE : _currentType;
        switch (mytype) {
            case TYPE_ELEMENT:
                myparent = _getElementFileName(views);
                if (!myparent) {
                    [_plugin, views] = this.pluginSplit(views);
                    mypaths = _paths(_plugin);
                    mydefaultPath = mypaths[0] ~ TYPE_ELEMENT ~ DIRECTORY_SEPARATOR;
                    throw new LogicException(
                        "You cannot extend an element which does not exist (%s).".format(mydefaultPath ~ views ~ _ext
                    ));
                }
                break;
            case TYPE_LAYOUT:
                myparent = _getLayoutFileName(views);
                break;
            default:
                myparent = _getTemplateFileName(views);
        }
        if (myparent == _current) {
            throw new LogicException("You cannot have templates extend themselves.");
        }
        if (isSet(_parents[myparent]) && _parents[myparent] == _current) {
            throw new LogicException("You cannot have templates extend in a loop.");
        }
       _parents[_current] = myparent;

        return this;
    }


    // Magic accessor for helpers.
    Helper __get(string attributeName) {
        return this.helpers().{attributeName};
    }

    /**
     * Interact with the HelperRegistry to load all the helpers.
     * /
    auto loadHelpers() {
        foreach (this.helpers as views: configData) {
            this.loadHelper(views, configData);
        }
        return this;
    }

    /**
     * Renders and returns output for given template filename with its
     * array of data. Handles parent/extended templates.
     * Params:
     * string mytemplateFile Filename of the template
     * @param array data Data to include in rendered view. If empty the current
     *  View.myviewVars will be used.
     * /
    protected string _render(string mytemplateFile, array data = []) {
        if (mydata.isEmpty) {
            mydata = this.viewVars;
        }
       _current = mytemplateFile;
        myinitialBlocks = count(this.Blocks.unclosed());

        this.dispatchEvent("View.beforeRenderFile", [mytemplateFile]);

        mycontent = _evaluate(mytemplateFile, mydata);

        myafterEvent = this.dispatchEvent("View.afterRenderFile", [mytemplateFile, mycontent]);
        if (myafterEvent.getResult() !isNull) {
            mycontent = myafterEvent.getResult();
        }
        if (isSet(_parents[mytemplateFile])) {
           _stack ~= this.fetch("content");
            this.assign("content", mycontent);

            mycontent = _render(_parents[mytemplateFile]);
            this.assign("content", array_pop(_stack));
        }
        myremainingBlocks = count(this.Blocks.unclosed());

        if (myinitialBlocks != myremainingBlocks) {
            throw new LogicException(
                "The `%s` block was left open. Blocks are not allowed to cross files."
                .format((string)this.Blocks.active())
            );
        }
        return mycontent;
    }

    /**
     * Sandbox method to evaluate a template / view script in.
     * Params:
     * string mytemplateFile Filename of the template.
     * @param array mydataForView Data to include in rendered view.
     * /
    protected string _evaluate(string mytemplateFile, array mydataForView) {
        extract(mydataForView);

        mybufferLevel = ob_get_level();
        ob_start();

        try {
            // Avoiding mytemplateFile here due to collision with extract() vars.
            include func_get_arg(0);
        } catch (Throwable myexception) {
            while (ob_get_level() > mybufferLevel) {
                ob_end_clean();
            }
            throw myexception;
        }
        return (string)ob_get_clean();
    }

    /**
     * Get the helper registry in use by this View class.
     * /
    HelperRegistry helpers() {
        return _helpers ??= new HelperRegistry(this);
    }

    /**
     * Adds a helper from within `initialize()` method.
     * Params:
     * string myhelper Helper.
     * @param IData[string] configData Config.
     * /
    protected void addHelper(string myhelper, IData[string] configData = null) {
        [_plugin, views] = pluginSplit(myhelper);
        if (_plugin) {
            configuration["className"] = myhelper;
        }
        this.helpers[views] = configData;
    }

    /**
     * Loads a helper. Delegates to the `HelperRegistry.load()` to load the helper.
     * You should use `addHelper()` instead of this method from the `initialize()` hook of `AppView` or other custom View classes.
     * /
    Helper loadHelper(string helperName, IData[string] settingsForHelper = null) {
        return this.helpers().load(helperName, settingsForHelper);
    }

    /**
     * Set sub-directory for this template files.
     * Params:
     * string mysubDir Sub-directory name.

     * @see \UIM\View\View.mysubDi 
     * /
    void setSubDir(string mysubDir) {
        thirs.subDir = mysubDir;
    }

    // Get sub-directory for this template files.
    string getSubDir() {
        return this.subDir;
    }
    
    // Returns the View"s controller name.
    @property string name() {
        return _name;
    }
        
    /**
     * Set The cache configuration View will use to store cached elements
     * Params:
     * string myelementCache Cache config name.
     * /
    void setElementCache(string cacheConfigName) {
        this.elementCache = cacheConfigName;
    }
    
    /**
     * Returns filename of given action"s template file as a string.
     * CamelCased action names will be under_scored by default.
     * This means that you can have LongActionNames that refer to
     * long_action_names.d templates. You can change the inflection rule by
     * overriding _inflectTemplateFileName.
     * Params:
     * string|null views Controller action to find template filename for
     * /
    protected string _getTemplateFileName(string views = null) {
        auto mytemplatePath  = "";
        auto mysubDir = "";

        if (_templatePath) {
            mytemplatePath = _templatePath ~ DIRECTORY_SEPARATOR;
        }
        if (_subDir != "") {
            mysubDir = _subDir ~ DIRECTORY_SEPARATOR;
            // Check if templatePath already terminates with subDir
            if (mytemplatePath != mysubDir && mytemplatePath.endsWith(mysubDir)) {
                mysubDir = "";
            }
        }
        views = views ? views : this.template;

        if (views.isEmpty) {
            throw new UimException("Template name not provided");
        }
        [_plugin, views] = this.pluginSplit(views);
        views = views.replace("/", DIRECTORY_SEPARATOR);

        if (!views.has(DIRECTORY_SEPARATOR) && views != "" && !views.startWith(".")) {
            views = mytemplatePath ~ mysubDir ~ _inflectTemplateFileName(views);
        } elseif (views.has(DIRECTORY_SEPARATOR)) {
            if (views[0] == DIRECTORY_SEPARATOR || views[1] == ":") {
                views = trim(views, DIRECTORY_SEPARATOR);
            } elseif (!_plugin || this.templatePath != this.name) {
                views = mytemplatePath ~ mysubDir ~ views;
            } else {
                views = mysubDir ~ views;
            }
        }
        views ~= _ext;
        mypaths = _paths(_plugin);
        foreach (mypaths as mypath) {
            if (isFile(mypath ~ views)) {
                return _checkFilePath(mypath ~ views, mypath);
            }
        }
        throw new MissingTemplateException(views, mypaths);
    }
    
    // Change the name of a view template file into underscored format.
    protected string _inflectTemplateFileName(string filename) {
        return Inflector.underscore(filename);
    }
    
    /**
     * Check that a view file path does not go outside of the defined template paths.
     *
     * Only paths that contain `..` will be checked, as they are the ones most likely to
     * have the ability to resolve to files outside of the template paths.
     * Params:
     * string filepath The path to the template file.
     * @param string mypath Base path that filepath should be inside of.
     * /
    protected string _checkFilePath(string filepath, string mypath) {
        if (!filepath.has("..")) {
            return filepath;
        }
        string myabsolute = realpath(filepath);
        if (myabsolute == false || !myabsolute.startWith(mypath)) {
            throw new DInvalidArgumentException(
                "Cannot use `%s` as a template, it is not within any view template path."
                .format(filepath));
        }
        return myabsolute;
    }
    
    /**
     * Splits a dot syntax plugin name into its plugin and filename.
     * If views does not have a dot, then index 0 will be null.
     * It checks if the plugin is loaded, else filename will stay unchanged for filenames containing dot
     * Params:
     * string views The name you want to plugin split.
     * @param bool myfallback If true uses the plugin set in the current Request when parsed plugin is not loaded
     * /
    array pluginSplit(string views, bool myfallback = true) {
        _plugin = null;
        [myfirst, mysecond] = pluginSplit(views);
        if (myfirst && Plugin.isLoaded(myfirst)) {
            views = mysecond;
            _plugin = myfirst;
        }
        if (isSet(this.plugin) && !_plugin && myfallback) {
            _plugin = this.plugin;
        }
        return [_plugin, views];
    }
    
    /**
     * Returns layout filename for this template as a string.
     * Params:
     * string|null views The name of the layout to find.
     * /
    protected string _getLayoutFileName(string views = null) {
        if (views is null) {
            if (this.layout.isEmpty) {
                throw new UimException(
                    "View.mylayout must be a non-empty string." .
                    "To disable layout rendering use method `View.disableAutoLayout()` instead."
                );
            }
            views = this.layout;
        }
        [_plugin, views] = this.pluginSplit(views);
        views ~= _ext;

        foreach (this.getLayoutPaths(_plugin) as mypath) {
            if (isFile(mypath ~ views)) {
                return _checkFilePath(mypath ~ views, mypath);
            }
        }
        mypaths = iterator_to_array(this.getLayoutPaths(_plugin));
        throw new MissingLayoutException(views, mypaths);
    }
    
    /**
     * Get an iterator for layout paths.
     * Params:
     * string|null _plugin The plugin to fetch paths for.
     * /
    protected DGenerator getLayoutPaths(string _plugin) {
        mysubDir = "";
        if (this.layoutPath) {
            mysubDir = this.layoutPath ~ DIRECTORY_SEPARATOR;
        }
        mylayoutPaths = _getSubPaths(TYPE_LAYOUT ~ DIRECTORY_SEPARATOR ~ mysubDir);

        foreach (_paths(_plugin) as mypath) {
            foreach (mylayoutPaths as mylayoutPath) {
                yield mypath ~ mylayoutPath;
            }
        }
    }
    
    /**
     * Finds an element filename, returns false on failure.
     * Params:
     * string elementname The name of the element to find.
     * @param bool _pluginCheck - if false will ignore the request"s plugin if parsed plugin is not loaded
     * /
    protected string|int|false _getElementFileName(string elementname, bool shouldCheckPlugin = true)|false
    {
        [_plugin, elementname] = this.pluginSplit(elementname, shouldCheckPlugin);

        elementname ~= _ext;
        foreach (this.getElementPaths(_plugin) as mypath) {
            if (isFile(mypath ~ elementname)) {
                return mypath ~ elementname;
            }
        }
        return false;
    }
    
    /**
     * Get an iterator for element paths.
     * Params:
     * string|null _plugin The plugin to fetch paths for.
     * /
    protected DGenerator getElementPaths(string _plugin) {
        myelementPaths = _getSubPaths(TYPE_ELEMENT);
        foreach (_paths(_plugin) as mypath) {
            foreach (myelementPaths as mysubdir) {
                yield mypath ~ mysubdir ~ DIRECTORY_SEPARATOR;
            }
        }
    }
    
    /**
     * Find all sub templates path, based on mybasePath
     * If a prefix is defined in the current request, this method will prepend
     * the prefixed template path to the mybasePath, cascading up in case the prefix
     * is nested.
     * This is essentially used to find prefixed template paths for elements
     * and layouts.
     * Params:
     * string mybasePath Base path on which to get the prefixed one.
     * /
    protected string[] _getSubPaths(string mybasePath) {
        mypaths = [mybasePath];
        if (this.request.getParam("prefix")) {
            string[] myprefixPath = split("/", this.request.getParam("prefix"));
            mypath = "";
            foreach (myprefixPath as myprefixPart) {
                mypath ~= Inflector.camelize(myprefixPart) ~ DIRECTORY_SEPARATOR;

                array_unshift(
                    mypaths,
                    mypath ~ mybasePath
                );
            }
        }
        return mypaths;
    }
    
    /**
     * Return all possible paths to find view files in order
     * Params:
     * string|null _plugin Optional plugin name to scan for view files.
     * @param bool mycached Set to false to force a refresh of view paths. Default true.
     * /
    protected string[] _paths(string _plugin = null, bool mycached = true) {
        if (mycached == true) {
            if (_plugin.isNull && !empty(_paths)) {
                return _paths;
            }
            if (_plugin !isNull && isSet(_pathsForPlugin[_plugin])) {
                return _pathsForPlugin[_plugin];
            }
        }
        mytemplatePaths = App.path(NAME_TEMPLATE);
        _pluginPaths = mythemePaths = null;
        if (!empty(_plugin)) {
            foreach (mytemplatePaths as mytemplatePath) {
                _pluginPaths ~= mytemplatePath
                    ~ PLUGIN_TEMPLATE_FOLDER
                    ~ DIRECTORY_SEPARATOR
                    ~ _plugin
                    ~ DIRECTORY_SEPARATOR;
            }
            _pluginPaths ~= Plugin.templatePath(_plugin);
        }
        if (!empty(this.theme)) {
            mythemePath = Plugin.templatePath(Inflector.camelize(this.theme));

            if (_plugin) {
                mythemePaths ~= mythemePath
                    ~ PLUGIN_TEMPLATE_FOLDER
                    ~ DIRECTORY_SEPARATOR
                    ~ _plugin
                    ~ DIRECTORY_SEPARATOR;
            }
            mythemePaths ~= mythemePath;
        }
        mypaths = array_merge(
            mythemePaths,
            _pluginPaths,
            mytemplatePaths,
            App.core("templates")
        );

        if (_plugin !isNull) {
            return _pathsForPlugin[_plugin] = mypaths;
        }
        return _paths = mypaths;
    }
    
    /**
     * Generate the cache configuration options for an element.
     * Params:
     * string elementname Element name
     * @param array data Data
     * @param IData[string] options Element options
     * /
    protected array _elementCache(string elementname, array data, IData[string] options) {
        if (isSet(options["cache"]["key"], options["cache"]["config"])) {
            /** @psalm-var array{key:string, config:string} mycache * /
            mycache = options["cache"];
            mycache["key"] = "element_" ~ mycache["key"];

            return mycache;
        }
        [_plugin, elementname] = this.pluginSplit(elementname);

        string _pluginKey = !_plugin.isNull
            ? Inflector.underscore(_plugin).replace("/", "_")
            : null;

        myelementKey = str_replace(["\\", "/"], "_", elementname);

        mycache = options["cache"];
        options.remove("cache");
        someKeys = array_merge(
            [_pluginKey, myelementKey],
            options.keys,
            mydata.keys
        );
        configData = [
            "config": this.elementCache,
            "key": join("_", someKeys),
        ];
        if (mycache.isArray) {
            configData = mycache + configData;
        }
        configuration["key"] = "element_" ~ configuration["key"];

        return configData;
    }
    
    /**
     * Renders an element and fires the before and afterRender callbacks for it
     * and writes to the cache if a cache is used
     * Params:
     * string filepath Element file path
     * @param array data Data to render
     * @param IData[string] options Element options
     * @triggers View.beforeRender this, [filepath]
     * @triggers View.afterRender this, [filepath, myelement]
     * /
    protected string _renderElement(string filepath, array data, IData[string] options) {
        mycurrent = _current;
        myrestore = _currentType;
       _currentType = TYPE_ELEMENT;

        if (options["callbacks"]) {
            this.dispatchEvent("View.beforeRender", [filepath]);
        }
        myelement = _render(filepath, array_merge(this.viewVars, mydata));

        if (options["callbacks"]) {
            this.dispatchEvent("View.afterRender", [filepath, myelement]);
        }
       _currentType = myrestore;
       _current = mycurrent;

        return myelement;
    } */
}
