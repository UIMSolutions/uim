module uim.views.classes.views.view;

import uim.views;

@safe:

/**
 * View, the V in the MVC triad. View interacts with Helpers and view variables passed
 * in from the controller to render the results of the controller action. Often this is HTML,
 * but can also take the form of Json, XML, PDF"s or streaming files.
 *
 * UIM uses a two-step-view pattern. This means that the template content is rendered first,
 * and then inserted into the selected layout. This also means you can pass data from the template to the
 * layout using `_set()`
 *
 * View class supports using plugins as themes. You can set
 *
 * ```
 * auto beforeRender(\UIM\Event\IEvent myevent)
 * {
 *    _viewBuilder().setTheme("SuperHot");
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

    this(Json[string] initData) {
        initialize(initData);
    }

    this(string newName) {
        this();
        _name(newName);
    }

    bool initialize(Json[string] initData = null) {
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

    // ViewBlock instance.
    protected DViewBlock[string] _blocks;
    // Get the names of all the existing blocks.
    string[] blockNames() {
        return _blocks.keys;
    }

    // A configuration array for helpers to be loaded.
    protected Json[string][string] _helpers;

    // The name of the subfolder containing templates for this View.
    protected string _templatePath = "";

    // #region consts
    const string TYPE_TEMPLATE = "template";

    // Constant for view file type "element"
    const string TYPE_ELEMENT = "element";

    // Constant for view file type "layout"
    const string TYPE_LAYOUT = "layout";

    // Constant for type used for App.path().
    const string NAME_TEMPLATE = "templates";

    // Constant for folder name containing files for overriding plugin templates.
    const string PLUGIN_TEMPLATE_FOLDER = "plugin";
    // #endregion consts

    /**
     * The name of the template file to render. The name specified
     * is the filename in `templates/<SubFolder>/` without the .d extension.
     */
    protected string _templateFileName;

    /**
     * The name of the layout file to render the template inside of. The name specified
     * is the filename of the layout in `templates/layout/` without the .d
     * extension.
     */
    protected string _layoutName = "default";

    // The name of the layouts subfolder containing layouts for this View.
    protected string _layoutPath = "";

    /**
     * The magic "match-all" content type that views can use to
     * behave as a fallback during content-type negotiation.
     */
    static const string TYPE_MATCH_ALL = "_match_all_";
    
    /**
     * Turns on or off UIM"s conventional mode of applying layout files. On by default.
     * Setting to off means that layouts will not be automatically applied to rendered templates.
     */
    protected bool _autoLayout = true;

    // An array of variables
    protected Json[string] _viewVars;

    /**
     * Sub-directory for this template file. This is often used for extension based routing.
     * Eg. With an `xml` extension, mysubDir would be `xml/`
     */
    protected string _subDir = "";

    // The view theme to use.
    protected string _viewTheme;

    /**
     * The Cache configuration View will use to store cached elements. Changing this will change
     * the default configuration elements are stored under. You can also choose a cache config
     * per element.
     */
    protected string _elementCache = "default";

   /**
     * An instance of a \UIM\Http\ServerRequest object that contains information about the current request.
     * This object contains all the information about a request and several methods for reading
     * additional information about the request.
     */
    protected IServerRequest _request;

    // Reference to the Response object
    protected DResponse myresponse;

    // #region contentType
        
        // Set the response content-type based on the view"s contentType()
        protected void setContentType() {
            /* 
            auto viewContentType = contentType();
            if (!viewContentType || viewContentType == TYPE_MATCH_ALL) {
                return;
            }
            
            auto response = _getResponse();
            auto myresponseType = myresponse.getHeaderLine("Content-Type");
            if (myresponseType.isEmpty || myresponseType.startsWith("text/html")) {
                response = response.withType(viewContentType);
            }
            _setResponse(response); */
    } 

// Mime-type this view class renders as.
static string contentType() {
    return null;
}
// #endregion contentType

    // Holds an array of paths.
    protected string[] _paths = null;

/* 
    use TCell() {
        cell as public;
    }
    
    // Helpers collection
    protected DHelperRegistry _helpers = null;

*/ 


 



    // List of variables to collect from the associated controller.
    protected string[] _passedVars = [
        "viewVars", "autoLayout", "helpers", "template", "layout", "name", "theme",
        "layoutPath", "templatePath", "plugin",
    ];


    // Holds an array of plugin paths.
    // TODO protected array<string[] _pathsForPlugin = null;

    // The names of views and their parents used with View.extend();
    protected string[] _parents = null;

    // The currently rendering view file. Used for resolving parent files.
    protected string _current = "";

    /**
     * Currently rendering an element. Used for finding parent fragments
     * for elements.
     */
    protected string _currentType = "";

    // Content stack, used for nested templates that all use View.extend();
    protected string[] _stack;

    // ViewBlock class.
    protected string _viewBlockClass = ViewBlock.classname;

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
     
     * Params:
     * \UIM\Http\ServerRequest|null _request Request instance.
     * @param \UIM\Http\Response|null myresponse Response instance.
     * @param \UIM\Event\IEventManager|null myeventManager Event manager instance.
     */
    this(
        ServerRequest serverRequest = null,
        Response myresponse = null,
        IEventManager myeventManager = null,
        Json[string] viewOptions = []
   ) {
        if (!myeventManager.isNull) {
            // Set the event manager before accessing the helper registry below
            // to ensure that helpers are registered as listeners with the manager when loaded.
            _setEventManager(myeventManager);
        }
        foreach (myvar; _passedVars) {
            if (isSet(viewOptions[myvar])) {
                _{myvar} = viewOptions[myvar];
            }
        }
        if (_helpers) {
            _helpers = _helpers().normalizeArray(_helpers);
        }
        configuration.update(array_diff_key(
            viewOptions,
            array_flip(_passedVars)
       ));

        _request = serverRequest ? serverRequest : (Router.getRequest() ?: new DServerRequest(["base": "", "url": "", "webroot": "/"]));
        _response = myresponse ?: new DResponse();
        _Blocks = new _viewBlockClass();
        _initialize();
        _loadHelpers();
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
     */
    bool initialize(Json[string] myConfiguration = null) {
       
    }



    // Gets the request instance.
    ServerRequest getRequest() {
        return _request;
    }

    /**
     * Sets the request objects and configures a number of controller properties
     * based on the contents of the request. The properties that get set are:
     *
     * - _request - To the _request parameter
     * - _plugin - To the value returned by _request.getParam("plugin")
     * Params:
     * \UIM\Http\ServerRequest _request Request instance.
     */
    void setRequest(DServerRequest _request) {
        _request = _request;
        _plugin = _request.getParam("plugin");
    }

    // Gets the response instance.
    Response getResponse() {
        return _response;
    }
    
    // Sets the response instance.
    auto setResponse(Response myresponse) {
        _response = myresponse;

        return this;
    }

    // Get path for templates files.
    string getTemplatePath() {
        return _templatePath;
    }

    // Set path for templates files.
    void setTemplatePath(string mypath) {
        _templatePath = mypath;
    }

    
    /**
     * Turns on or off UIM"s conventional mode of applying layout files.
     * On by default. Setting to off means that layouts will not be
     * automatically applied to rendered views.
     * Params:
     * bool myenable Boolean to turn on/off.
     */
    auto enableAutoLayout(bool myenable = true) {
        _autoLayout = myenable;

        return this;
    }

    /**
     * Turns off UIM"s conventional mode of applying layout files.
     * Layouts will not be automatically applied to rendered views.
     */
    auto disableAutoLayout() {
        _autoLayout = false;

        return this;
    }
    
    // Get the current view theme.
    string getTheme() {
        return _theme;
    }

    /**
     * Set the view theme to use.
     * Params:
     * string mytheme Theme name.
     */
    void setTheme(string themeName) {
        _theme = themeName;
    }

    /**
     * Get the name of the template file to render. The name specified is the
     * filename in `templates/<SubFolder>/` without the .d extension.
     */
    string getTemplate() {
        return _template;
    }

    /**
     * Set the name of the template file to render. The name specified is the
     * filename in `templates/<SubFolder>/` without the .d extension.
     * Params:
     * string views Template file name to set.
     */
    void setTemplate(string views) {
        _template = views;
    }

    /**
     * Get the name of the layout file to render the template inside of.
     * The name specified is the filename of the layout in `templates/layout/`
     * without the .d extension.
     */
    string getLayout() {
        return _layout;
    }

    /**
     * Set the name of the layout file to render the template inside of.
     * The name specified is the filename of the layout in `templates/layout/`
     * without the .d extension.
     * Params:
     * string views Layout file name to set.
     */
    auto setLayout(string fileName) {
        _layout = fileName;

        return this;
    }

    /**
     * Renders a piece of D with provided parameters and returns HTML, XML, or any other string.
     *
     * This realizes the concept of Elements, (or "partial layouts") and the myparams array is used to send
     * data to be used in the element. Elements can be cached improving performance by using the `cache` option.
     * Params:
     * string templatefilename Name of template file in the `templates/element/` folder,
     * or `_plugin.template` to use the template element from _plugin. If the element
     * is not found in the plugin, the normal view path cascade will be searched.
     * @param Json[string] data Array of data to be made available to the rendered view (i.e. the Element)
     * @param Json[string] options Array of options. Possible keys are:
     *
     * - `cache` - Can either be `true`, to enable caching using the config in View.myelementCache. Or an array
     * If an array, the following keys can be used:
     *
     * - `config` - Used to store the cached element in a custom cache configuration.
     * - `key` - Used to define the key used in the Cache.write(). It will be prefixed with `element_`
     *
     * - `callbacks` - Set to true to fire beforeRender and afterRender helper callbacks for this element.
     * Defaults to false.
     * - `ignoreMissing` - Used to allow missing elements. Set to true to not throw exceptions.
     * - `plugin` - setting to false will force to use the application"s element from plugin templates, when the
     * plugin has element with same name. Defaults to true
     */
    string element(string templatefilename, Json[string] data = [], Json[string] options  = null) {
        auto updatedOptions = options.update["callbacks": false.toJson, "cache": Json(null), "plugin": Json(null), "ignoreMissing": false.toJson];
        if (isSet(options["cache"])) {
            options["cache"] = _elementCache(
                templatefilename,
                mydata,
                array_diff_key(options, ["callbacks": false.toJson, "plugin": Json(null), "ignoreMissing": Json(null)])
           );
        }

        bool _pluginCheck = options["plugin"] != false;
        auto filepath = _getElementFileName(templatefilename, _pluginCheck);
        if (filepath && options["cache"]) {
            return _cache(void () use (filepath, mydata, options) {
                writeln(_renderElement(filepath, mydata, options);
            }, options["cache"]);
        }
        if (filepath) {
            return _renderElement(filepath, mydata, options);
        }
        if (options["ignoreMissing"]) {
            return null;
        }
        [_plugin, myelementName] = _pluginSplit(templatefilename, _pluginCheck);
        auto mypaths = iterator_to_array(_getElementPaths(_plugin));
        throw new DMissingElementException([templatefilename ~ _ext, myelementName ~ _ext], mypaths);
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
     */
    string cache(callable myblock, Json[string] options  = null) {
        Json[string] options = options.merge([
            "key": "".toJson, 
            "config": Json(_elementCache)]);
        
        if (options.isEmpty("key")) {
            throw new DInvalidArgumentException("Cannot cache content with an empty key");
        }
        
        auto result = Cache.read(options["key"], options["config"]);
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
     * or `_plugin.template` to check the template element from _plugin. If the element
     * is not found in the plugin, the normal view path cascade will be searched.
     */
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
     * string mytemplate Name of template file to use
     * @param string|null mylayout Layout to use. False to disable.
     */
    string render(string mytemplate = null, string|null mylayout = null) {
        mydefaultLayout = "";
        mydefaultAutoLayout = null;
        if (mylayout == false) {
            mydefaultAutoLayout = _autoLayout;
            _autoLayout = false;
        } elseif (mylayout !is null) {
            mydefaultLayout = _layout;
            _layout = mylayout;
        }
        mytemplateFileName = _getTemplateFileName(mytemplate);
       _currentType = TYPE_TEMPLATE;
        _dispatchEvent("View.beforeRender", [mytemplateFileName]);
        _Blocks.set("content", _render(mytemplateFileName));
        _dispatchEvent("View.afterRender", [mytemplateFileName]);

        if (_autoLayout) {
            if (_layout.isEmpty) {
                throw new DException(
                    "View.mylayout must be a non-empty string." .
                    "To disable layout rendering use method `View.disableAutoLayout()` instead."
               );
            }
            _Blocks.set("content", _renderLayout("", _layout));
        }
        if (mylayout !is null) {
            _layout = mydefaultLayout;
        }
        if (mydefaultAutoLayout !is null) {
            _autoLayout = mydefaultAutoLayout;
        }
        return _Blocks.get("content");
    }
    
    /**
     * Renders a layout. Returns output from _render().
     *
     * Several variables are created for use in layout.
     * Params:
     * string mycontent Content to render in a template, wrapped by the surrounding layout.
     * @param string mylayout Layout name
     */
    string renderLayout(string mycontent, string mylayout = null) {
        mylayoutFileName = _getLayoutFileName(mylayout);

        if (!mycontent.isEmpty) {
            _Blocks.set("content", mycontent);
        }
        _dispatchEvent("View.beforeLayout", [mylayoutFileName]);

        string mytitle = _Blocks.get("title");
        if (mytitle.isEmpty) {
            mytitle = Inflector.humanize(_templatePath.replace(DIRECTORY_SEPARATOR, "/"));
            _Blocks.set("title", mytitle);
        }
       _currentType = TYPE_LAYOUT;
        _Blocks.set("content", _render(mylayoutFileName));

        _dispatchEvent("View.afterLayout", [mylayoutFileName]);

        return _Blocks.get("content");
    }

    // Returns a list of variables available in the current View context
    string[] getVars() {
        return _viewVars.keys;
    }
    
    // Returns the contents of the given View variable.
    Json get(string valueName, Json defaultValue = Json(null)) {
        return _viewVars.get(valueName, defaultValue);
    }

    /**
     * Saves a variable or an associative array of variables for use inside a template.
     * Params:
     * string[] views A string or an array of data.
     * @param Json aValue Value in case views is a string (which then works as the key).
     * Unused if views is an associative array, otherwise serves as the values to views"s keys.
     */
    void set(string[] views, Json aValue = null) {
        if (views.isArray) {
            if (myvalue.isArray) {
                /** @var array|false mydata Coerce Dstan to accept failure case */
                mydata = array_combine(views, myvalue);
                if (mydata == false) {
                    throw new DException(
                        "Invalid data provided for array_combine() to work: Both views and myvalue require same count."
                   );
                }
            } else {
                mydata = views;
            }
        } else {
            mydata = [views: myvalue];
        }
        _viewVars = mydata + _viewVars;
    }



    /**
     * Start capturing output for a "block"
     *
     * You can use start on a block multiple times to
     * append or prepend content in a capture mode.
     *
     * ```
     * Append content to an existing block.
     * _start("content");
     * writeln(_fetch("content");
     * writeln("Some new content";
     * _end();
     *
     * Prepend content to an existing block
     * _start("content");
     * writeln("Some new content";
     * writeln(_fetch("content");
     * _end();
     * ```
     * Params:
     * string views The name of the block to capture for.
     */
    void start(string blockName) {
        _blocks.start(blockName);
    }

    /**
     * Append to an existing or new block.
     *
     * Appending to a new block will create the block.
     * Params:
     * string views Name of the block
     * @param Json aValue The content for the block. Value will be type cast
     * to string.
     */
    void append(string blockName, Json aValue = null) {
        _blocks.concat(blockName, myvalue);
    }
    
    /**
     * Prepend to an existing or new block.
     * Prepending to a new block will create the block.
     */
    void prepend(string blockName, Json blockContent) {
        _blocks.concat(blockName, blockContent, ViewBlock.PREPEND);
    }

    /**
     * Set the content for a block. This will overwrite any
     * existing content.
     * Params:
     * @param Json aValue The content for the block. Value will be type cast
     * to string.
     */
    void assign(string blockName, Json aValue) {
        _Blocks.set(blockName, myvalue);
    }

    /**
     * Reset the content for a block. This will overwrite any
     * existing content.
     * Params:
     * string views Name of the block
     */
    void reset(string views) {
        _assign(views, "");
    }
    
    /**
     * Fetch the content for a block. If a block is
     * empty or undefined "" will be returned.
     */
    string fetch(string blockName, string defaultText = null) {
        return _blocks.get(blockName, defaultText);
    }

    // End a capturing block. The compliment to View.start()
    void end() {
        _Blocks.end();
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
     */
    void extend(string views) {
        mytype = views[0] == "/" ? TYPE_TEMPLATE : _currentType;
        switch (mytype) {
            case TYPE_ELEMENT:
                myparent = _getElementFileName(views);
                if (!myparent) {
                    [_plugin, views] = _pluginSplit(views);
                    mypaths = _paths(_plugin);
                    mydefaultPath = mypaths[0] ~ TYPE_ELEMENT ~ DIRECTORY_SEPARATOR;
                    throw new DLogicException(
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
            throw new DLogicException("You cannot have templates extend themselves.");
        }
        if (isSet(_parents[myparent]) && _parents[myparent] == _current) {
            throw new DLogicException("You cannot have templates extend in a loop.");
        }
       _parents[_current] = myparent;
    }


    // Magic accessor for helpers.
    Helper __get(string attributeName) {
        return _helpers().{attributeName};
    }

    /**
     * Interact with the HelperRegistry to load all the helpers.
     */
    auto loadHelpers() {
        foreach (_helpers as views: configData) {
            _loadHelper(views, configData);
        }
        return this;
    }

    /**
     * Renders and returns output for given template filename with its
     * array of data. Handles parent/extended templates.
     * Params:
     * string mytemplateFile Filename of the template
     * @param Json[string] data Data to include in rendered view. If empty the current
     * View.myviewVars will be used.
     */
    protected string _render(string mytemplateFile, Json[string] data = []) {
        if (mydata.isEmpty) {
            mydata = _viewVars;
        }
       _current = mytemplateFile;
        myinitialBlocks = count(_Blocks.unclosed());

        _dispatchEvent("View.beforeRenderFile", [mytemplateFile]);

        mycontent = _evaluate(mytemplateFile, mydata);

        myafterEvent = _dispatchEvent("View.afterRenderFile", [mytemplateFile, mycontent]);
        if (myafterEvent.getResult() !is null) {
            mycontent = myafterEvent.getResult();
        }
        if (isSet(_parents[mytemplateFile])) {
           _stack ~= _fetch("content");
            _assign("content", mycontent);

            mycontent = _render(_parents[mytemplateFile]);
            _assign("content", array_pop(_stack));
        }
        myremainingBlocks = count(_Blocks.unclosed());

        if (myinitialBlocks != myremainingBlocks) {
            throw new DLogicException(
                "The `%s` block was left open. Blocks are not allowed to cross files."
                .format(/* (string) */_Blocks.active())
           );
        }
        return mycontent;
    }

    /**
     * Sandbox method to evaluate a template / view script in.
     * Params:
     * string mytemplateFile Filename of the template.
     * @param array mydataForView Data to include in rendered view.
     */
    protected string _evaluate(string mytemplateFile, Json[string] mydataForView) {
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
        return /* (string) */ob_get_clean();
    }

    /**
     * Get the helper registry in use by this View class.
     */
    HelperRegistry helpers() {
        return _helpers ??= new DHelperRegistry(this);
    }

    /**
     * Adds a helper from within `initialize()` method.
     * Params:
     * string myhelper Helper.
     * @param Json[string] configData Config.
     */
    protected void addHelper(string myhelper, Json[string] configData = null) {
        [_plugin, views] = pluginSplit(myhelper);
        if (_plugin) {
            configuration.get("className"] = myhelper;
        }
        _helpers[views] = configData;
    }

    /**
     * Loads a helper. Delegates to the `HelperRegistry.load()` to load the helper.
     * You should use `addHelper()` instead of this method from the `initialize()` hook of `AppView` or other custom View classes.
     */
    Helper loadHelper(string helperName, Json[string] settingsForHelper = null) {
        return _helpers().load(helperName, settingsForHelper);
    }

    /**
     * Set sub-directory for this template files.
     * Params:
     * string mysubDir Sub-directory name.
     */
    void setSubDir(string mysubDir) {
        thirs.subDir = mysubDir;
    }

    // Get sub-directory for this template files.
    string getSubDir() {
        return _subDir;
    }
    
    // Returns the View"s controller name.
    @property string name() {
        return _name;
    }
        
    /**
     * Set The cache configuration View will use to store cached elements
     * Params:
     * string myelementCache Cache config name.
     */
    void setElementCache(string cacheConfigName) {
        _elementCache = cacheConfigName;
    }
    
    /**
     * Returns filename of given action"s template file as a string.
     * CamelCased action names will be under_scored by default.
     * This means that you can have LongActionNames that refer to
     * long_action_names.d templates. You can change the inflection rule by
     * overriding _inflectTemplateFileName.
     * Params:
     * string views Controller action to find template filename for
     */
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
        views = views ? views : _template;

        if (views.isEmpty) {
            throw new DException("Template name not provided");
        }
        [_plugin, views] = _pluginSplit(views);
        views = views.replace("/", DIRECTORY_SEPARATOR);

        if (!views.has(DIRECTORY_SEPARATOR) && views != "" && !views.startWith(".")) {
            views = mytemplatePath ~ mysubDir ~ _inflectTemplateFileName(views);
        } elseif (views.has(DIRECTORY_SEPARATOR)) {
            if (views[0] == DIRECTORY_SEPARATOR || views[1] == ": ") {
                views = strip(views, DIRECTORY_SEPARATOR);
            } elseif (!_plugin || _templatePath != _name) {
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
        throw new DMissingTemplateException(views, mypaths);
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
     */
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
     */
    array pluginSplit(string views, bool myfallback = true) {
        _plugin = null;
        [myfirst, mysecond] = pluginSplit(views);
        if (myfirst && Plugin.isLoaded(myfirst)) {
            views = mysecond;
            _plugin = myfirst;
        }
        if (isSet(_plugin) && !_plugin && myfallback) {
            _plugin = _plugin;
        }
        return [_plugin, views];
    }
    
    /**
     * Returns layout filename for this template as a string.
     * Params:
     * string views The name of the layout to find.
     */
    protected string _getLayoutFileName(string views = null) {
        if (views.isNull) {
            if (_layout.isEmpty) {
                throw new DException(
                    "View.mylayout must be a non-empty string." .
                    "To disable layout rendering use method `View.disableAutoLayout()` instead."
               );
            }
            views = _layout;
        }
        [_plugin, views] = _pluginSplit(views);
        views ~= _ext;

        foreach (_getLayoutPaths(_plugin) as mypath) {
            if (isFile(mypath ~ views)) {
                return _checkFilePath(mypath ~ views, mypath);
            }
        }
        mypaths = iterator_to_array(_getLayoutPaths(_plugin));
        throw new DMissingLayoutException(views, mypaths);
    }
    
    /**
     * Get an iterator for layout paths.
     * Params:
     * string _plugin The plugin to fetch paths for.
     */
    protected DGenerator getLayoutPaths(string _plugin) {
        mysubDir = "";
        if (_layoutPath) {
            mysubDir = _layoutPath ~ DIRECTORY_SEPARATOR;
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
     */
    protected string|int|false _getElementFileName(string elementname, bool shouldCheckPlugin = true)|false
    {
        [_plugin, elementname] = _pluginSplit(elementname, shouldCheckPlugin);

        elementname ~= _ext;
        foreach (_getElementPaths(_plugin) as mypath) {
            if (isFile(mypath ~ elementname)) {
                return mypath ~ elementname;
            }
        }
        return false;
    }
    
    /**
     * Get an iterator for element paths.
     * Params:
     * string _plugin The plugin to fetch paths for.
     */
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
     */
    protected string[] _getSubPaths(string mybasePath) {
        mypaths = [mybasePath];
        if (_request.getParam("prefix")) {
            string[] myprefixPath =_request.getParam("prefix"). split("/");
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
     * string _plugin Optional plugin name to scan for view files.
     * @param bool mycached Set to false to force a refresh of view paths. Default true.
     */
    protected string[] _paths(string _plugin = null, bool mycached = true) {
        if (mycached == true) {
            if (_plugin.isNull && !_paths.isEmpty) {
                return _paths;
            }
            if (_plugin !is null && isSet(_pathsForPlugin[_plugin])) {
                return _pathsForPlugin[_plugin];
            }
        }
        mytemplatePaths = App.path(NAME_TEMPLATE);
        _pluginPaths = mythemePaths = null;
        if (!_plugin.isEmpty) {
            foreach (mytemplatePaths as mytemplatePath) {
                _pluginPaths ~= mytemplatePath
                    ~ PLUGIN_TEMPLATE_FOLDER
                    ~ DIRECTORY_SEPARATOR
                    ~ _plugin
                    ~ DIRECTORY_SEPARATOR;
            }
            _pluginPaths ~= Plugin.templatePath(_plugin);
        }
        if (!_theme.isEmpty) {
            mythemePath = Plugin.templatePath(Inflector.camelize(_theme));

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

        if (_plugin !is null) {
            return _pathsForPlugin[_plugin] = mypaths;
        }
        return _paths = mypaths;
    }
    
    /**
     * Generate the cache configuration options for an element.
     * Params:
     * string elementname Element name
     * @param Json[string] data Data
     * @param Json[string] options Element options
     */
    protected Json[string] _elementCache(string elementname, Json[string] data, Json[string] options) {
        if (isSet(options["cache.key"], options["cache.config"])) {
            /** @psalm-var array{key:string, config:string} mycache */
            mycache = options["cache"];
            mycache["key"] = "element_" ~ mycache["key"];

            return mycache;
        }
        [_plugin, elementname] = _pluginSplit(elementname);

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
            "config": _elementCache,
            "key": someKeys.join("_"),
        ];
        if (mycache.isArray) {
            configData = mycache + configData;
        }
        configuration.get("key"] = "element_" ~ configuration.get("key"];

        return configData;
    }
    
    /**
     * Renders an element and fires the before and afterRender callbacks for it
     * and writes to the cache if a cache is used
     * Params:
     * string filepath Element file path
     * @param Json[string] data Data to render
     */
    protected string _renderElement(string filepath, Json[string] data, Json[string] elementOptions = null) {
        auto mycurrent = _current;
        auto myrestore = _currentType;
       _currentType = TYPE_ELEMENT;

        if (elementOptions["callbacks"]) {
            _dispatchEvent("View.beforeRender", [filepath]);
        }
        auto myelement = _render(filepath, array_merge(_viewVars, mydata));

        if (elementOptions["callbacks"]) {
            _dispatchEvent("View.afterRender", [filepath, myelement]);
        }
       _currentType = myrestore;
       _current = mycurrent;

        return myelement;
    }
}
