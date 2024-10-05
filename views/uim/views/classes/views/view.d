/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.views.view;UIMExceptionUIMExceptionUIMExceptionUIMException

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
 *    _viewBuilder().theme("SuperHot");
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
class DView : UIMObject, IView { //  }: IEventDispatcher {
    mixin(ViewThis!());

    // @use \UIM\Event\EventDispatcherTrait<\UIM\View\View>
    mixin TEventDispatcher;
    // mixin TLog;

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    // The name of the plugin.
    mixin(TProperty!("string", "plugin"));

    // Name of the controller that created the View if any.
    protected string _viewControllerName = "";

    /**
     * Currently rendering an element. Used for finding parent fragments
     * for elements.
     */
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
     * is the filename of the layout in `templates/layout/` without the .d extension.
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
    protected bool _autoLayoutEnabled = true;

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
    // protected IServerRequest _request;

    // Reference to the Response object
    // protected DResponse _response;

    // #region contentType
        
        // Set the response content-type based on the view"s contentType()
        protected void setContentType() {
            /* 
            auto viewContentType = contentType();
            if (!viewContentType || viewContentType == TYPE_MATCH_ALL) {
                return;
            }
            
            auto response = _getResponse();
            auto myresponseType = _response.getHeaderLine("Content-Type");
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
    protected DViewHelperRegistry _helpers = null;

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

    // Content stack, used for nested templates that all use View.extend();
    protected string[] _stack;

    // ViewBlock class.
    protected string _viewBlockClass; // = ViewBlock.classname;

    /* this(
        DServerRequest serverRequest = null,
        DResponse _response = null,
        IEventManager myeventManager = null,
        Json[string] viewOptions= null
   ) {
        if (!myeventManager.isNull) {
            // Set the event manager before accessing the helper registry below
            // to ensure that helpers are registered as listeners with the manager when loaded.
            _eventManager(myeventManager);
        }
        foreach (myvar; _passedVars) {
            if (viewOptions.hasKey(myvar)) {
                /* _{myvar} = viewoptions.get(myvar); * /
            }
        }
        if (_helpers) {
            _helpers = _helpers().normalizeArray(_helpers);
        }
        configuration.set(array_diffinternalKey(
            viewOptions,
            array_flip(_passedVars)
       ));

        // _request = serverRequest ? serverRequest : (Router.getRequest() ?: new DServerRequest(["base": "", "url": "", "webroot": "/"]));
        /* _response = _response ?: new DResponse();
        _blocks = new _viewBlockClass();
        _initialize();
        _loadHelpers(); * /
    } */
    
    // Gets the request instance.
    /* ServerRequest getRequest() {
        return _request;
    } */

    /**
     * Sets the request objects and configures a number of controller properties
     * based on the contents of the request. The properties that get set are:
     *
     * - _request - To the _request parameter
     * - _plugin - To the value returned by _request.getParam("plugin")
     * Params:
     * \UIM\Http\ServerRequest _request Request instance.
     */
    /* void setRequest(DServerRequest _request) {
        _request = _request;
        _plugin = _request.getParam("plugin");
    } */

    // Gets the response instance.
    /* Response getResponse() {
        return _response;
    } */
    
    // Sets the response instance.
    /* auto setResponse(Response _response) {
        _response = _response;

        return this;
    } */

    // Get path for templates files.
    string getTemplatePath() {
        return _templatePath;
    }

    // Set path for templates files.
    void setTemplatePath(string path) {
        _templatePath = path;
    }

    
    /**
     * Turns on or off UIM"s conventional mode of applying layout files.
     * On by default. Setting to off means that layouts will not be automatically applied to rendered views.
     */
    IView enableAutoLayout(bool enable = true) {
        _autoLayoutEnabled = enable;
        return this;
    }

    /**
     * Turns off UIM"s conventional mode of applying layout files.
     * Layouts will not be automatically applied to rendered views.
     */
    IView disableAutoLayout() {
        _autoLayoutEnabled = false;
        return this;
    }
    
    // Get the current view theme.
    protected string _theme;
    string theme() {
        return _theme;
    }

    // Set the view theme to use.
    IView theme(string name) {
        _theme = name;
        return this; 
    }

    // Get the name of the template file to render.
    protected string _templateFilename;
    string templateFilename() {
        return _templateFilename;
    }

    // Set the name of the template file to render.
    IView templateFilename(string views) {
        _templateFilename = views;
        return this; 
    }

    /**
     * Get the name of the layout file to render the template inside of.
     * The name specified is the filename of the layout in `templates/layout/`
     * without the .d extension.
     */
    protected string _layout;
    string getLayout() {
        return _layout;
    }

    /**
     * Set the name of the layout file to render the template inside of.
     * The name specified is the filename of the layout in `templates/layout/`
     * without the .d extension.
     */
    auto setLayout(string fileName) {
        _layout = fileName;

        return this;
    }

    /**
     * Renders a piece of UIM with provided parameters and returns HTML, XML, or any other string.
     *
     * This realizes the concept of Elements, (or "partial layouts") and the params array is used to send
     * data to be used in the element. Elements can be cached improving performance by using the `cache` option.
     * Params:
     * string templatefilename Name of template file in the `templates/element/` folder,
     * or `_plugin.template` to use the template element from _plugin. If the element
     * is not found in the plugin, the normal view path cascade will be searched.
     */
    string element(string templatefilename, Json[string] data = null, Json[string] options = null) {
        options
            .merge("callbacks", false)
            .merge("cache", Json(null))
            .merge("plugin", Json(null))
            .merge("ignoreMissing", false);

        /* if (options.hasKey("cache")) {
            options.set("cache", elementCache(
                templatefilename,
                data,
                array_diffinternalKey(options, createMap!(string, Json)
                    .set("callbacks", false)
                    .set("plugin", Json(null))
                    .set("ignoreMissing", Json(null)))));
        }

        bool _pluginCheck = options.get("plugin") == true;
        auto filepath = _getElementFileName(templatefilename, _pluginCheck);
        if (!filepath.isEmpty && options.hasKey("cache")) {
            /* return _cache(void () use (filepath, data, options) {
                writeln(_renderElement(filepath, data, options));
            }, options.get("cache")); * /
        }
        if (filepath) {
            return _renderElement(filepath, data, options);
        }
        if (options.hasKey("ignoreMissing")) {
            return null;
        } */
       /*  [_plugin, myelementName] = _pluginSplit(templatefilename, _pluginCheck);
        auto paths = iterator_to_array(_getElementPaths(_plugin));
        throw new DMissingElementException([templatefilename ~ _ext, myelementName ~ _ext], paths); */
        return null;
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
    /* string cache(callable myblock, Json[string] options = null) {
        options
            .merge("key", "".toJson) 
            .merge("config", Json(_elementCache));
        
        if (options.isEmpty("key")) {
            throw new DInvalidArgumentException("Cannot cache content with an empty key");
        }
        
        auto result = Cache.read(options.get("key"), options.get("config"));
        if (result) {
            return result;
        }
        mybufferLevel = ob_get_level();
        ob_start();

        try {
            myblock();
        } catch (Throwable exception) {
            while (ob_get_level() > mybufferLevel) {
                ob_end_clean();
            }
            throw exception;
        }
        result = to!string(ob_get_clean());

        Cache.write(options.get("key"), result, options.get("config"));

        return result;
    } */

    /**
     * Checks if an element exists
     * Params:
     * string templatefilename Name of template file in the `templates/element/` folder,
     * or `_plugin.template` to check the template element from _plugin. If the element
     * is not found in the plugin, the normal view path cascade will be searched.
     */
    bool elementhasKey(string templatefilename) {
        /* return /* (bool) * /_getElementFileName(templatefilename); */
        return false;
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
     */
    string render(string templateName = null, string layoutName = null) {
        auto defaultLayout = "";
        auto defaultAutoLayout = null;
        /* if (layoutName == false) {
            defaultAutoLayout = _autoLayoutEnabled;
            _autoLayoutEnabled = false;
        } else if (layoutName !is null) {
            defaultLayout = _layout;
            _layout = layoutName;
        } */
        /* mytemplateFileName = _getTemplateFileName(templateName);
       _currentType = TYPE_TEMPLATE;
        _dispatchEvent("View.beforeRender", [mytemplateFileName]);
        _blocks.set("content", _render(mytemplateFileName));
        _dispatchEvent("View.afterRender", [mytemplateFileName]);

        if (_autoLayoutEnabled) {
            if (_layout.isEmpty) {
                throw new DException(
                    "View.layoutName must be a non-empty string." ~
                    "To disable layout rendering use method `View.disableAutoLayout()` instead."
               );
            }
            _blocks.set("content", _renderLayout("", _layout));
        }
        if (layoutName !is null) {
            _layout = defaultLayout;
        }
        if (defaultAutoLayout !is null) {
            _autoLayoutEnabled = defaultAutoLayout;
        }
        return _blocks.get("content"); */
        return null; 
    }
    
    /**
     * Renders a layout. Returns output from _render().
     *
     * Several variables are created for use in layout.
     */
    string renderLayout(string mycontent, string layoutName = null) {
        /* auto layoutFilename = _getLayoutFileName(mylaylayoutNameout);

        if (!mycontent.isEmpty) {
            _blocks.set("content", mycontent);
        } */
        // _dispatchEvent("View.beforeLayout", [layoutFilename]);

        /* string mytitle = _blocks.get("title");
        if (mytitle.isEmpty) {
            mytitle = _templatePath.replace(DIRECTORY_SEPARATOR, "/").humanize;
            _blocks.set("title", mytitle);
        }
       _currentType = TYPE_LAYOUT; */
       /*  _blocks.set("content", _render(layoutFilename));

        _dispatchEvent("View.afterLayout", [layoutFilename]);

        return _blocks.get("content"); */
        return null; 
    }

    // Returns a list of variables available in the current View context
    string[] getVars() {
        return _viewVars.keys;
    }
    
    // Returns the contents of the given View variable.
    Json get(string valueName, Json defaultValue = Json(null)) {
        return _viewVars.get(valueName, defaultValue);
    }

    // Saves a variable or an associative array of variables for use inside a template.
    void set(string[] views, Json value = Json(null)) {
        /* if (views.isArray) {
            if (myvalue.isArray) {
                /** @var array|false data Coerce Dstan to accept failure case * /
                auto data = combine(views, myvalue);
                if (data.isEmpty) {
                    throw new DException(
                        "Invalid data provided for array_combine() to work: Both views and myvalue require same count."
                   );
                }
            } else {
                data = views;
            }
        } else {
            data = [views: myvalue];
        }
        _viewVars = data + _viewVars; */
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
        // _blocks.start(blockName);
    }

    /**
     * Append to an existing or new block.
     * Appending to a new block will create the block.
     */
    void append(string blockName, Json value = Json(null)) {
        // _blocks.concat(blockName, myvalue);
    }
    
    /**
     * Prepend to an existing or new block.
     * Prepending to a new block will create the block.
     */
    void prepend(string blockName, Json blockContent) {
       //  _blocks.concat(blockName, blockContent, ViewBlock.PREPEND);
    }

    /**
     * Set the content for a block. This will overwrite any
     * existing content.
     */
    void assign(string blockName, Json value) {
       //  _blocks.set(blockName, value);
    }

    /**
     * Reset the content for a block. This will overwrite any
     * existing content.
     */
    void reset(string blockName) {
       // _assign(blockName, "");
    }
    
    /**
     * Fetch the content for a block. If a block is
     * empty or undefined "" will be returned.
     */
    string fetch(string blockName, string defaultText = null) {
        // return _blocks.get(blockName, defaultText);
        return null;
    }

    // End a capturing block. The compliment to View.start()
    void end() {
        // _blocks.end();
    }

    // Check if a block exists
   bool hasKey(string blockName) {
        return _blocks.hasKey(blockName);
    }

    /**
     * Provides template or element extension/inheritance. Templates can : a
     * parent template and populate blocks in the parent template.
     */
    void extend(string[] views) {
        auto type = views[0] == "/" ? TYPE_TEMPLATE : _currentType;
        string parentName;
       /*  switch (type) {
            case TYPE_ELEMENT:
                // parentName = _getElementFileName(views);
                if (!parentName) {
                    /* [_plugin, views] = _pluginSplit(views);
                    paths =  paths(_plugin);
                    mydefaultPath = paths[0] ~ TYPE_ELEMENT ~ DIRECTORY_SEPARATOR;
                     *//* throw new DLogicException(
                        "You cannot extend an element which does not exist (%s).".format(mydefaultPath ~ views ~ _ext
                   )); * /
                }
                break;
            case TYPE_LAYOUT:
                parentName = _getLayoutFileName(views);
                break;
            default:
                break; // parentName = _getTemplateFileName(views);
        }
        if (parentName == _current) {
            // throw new DLogicException("You cannot have templates extend themselves.");
        } */
        /* if (_parents.hasKey(parentName) && _parents[parentName] == _current) {
            // throw new DLogicException("You cannot have templates extend in a loop.");
        } */
       // _parents[_current] = parentName;
    }


    // Magic accessor for helpers.
    /* Helper __get(string attributeName) {
        return _helpers().{attributeName};
    } */

    // Interact with the HelperRegistry to load all the helpers.
    /* auto loadHelpers() {
        foreach (views, configData; _helpers) {
            _loadHelper(views, configData);
        }
        return this;
    } */

    /**
     * Renders and returns output for given template filename with its
     * array of data. Handles parent/extended templates.
     */
    protected string _render(string templateFilename, Json[string] data = null) {
        /* if (data.isEmpty) {
            data = _viewVars;
        }
       _current = templateFilename;
        auto myinitialBlocks = count(_blocks.unclosed());

        _dispatchEvent("View.beforeRenderFile", [templateFilename]);

        auto mycontent = _evaluate(templateFilename, data);

        auto myafterEvent = _dispatchEvent("View.afterRenderFile", [templateFilename, mycontent]);
        if (myafterEvent.getResult() !is null) {
            mycontent = myafterEvent.getResult();
        } */
        /* if (_parents.hasKey(templateFilename)) {
           _stack ~= _fetch("content");
            _assign("content", mycontent);

            mycontent = _render(_parents[templateFilename]);
            _assign("content", _stack.pop());
        } */
        /* myremainingBlocks = count(_blocks.unclosed());

        if (myinitialBlocks != myremainingBlocks) {
            throw new DLogicException(
                "The `%s` block was left open. Blocks are not allowed to cross files."
                .format(/* (string) * /_blocks.active())
           );
        }
        return mycontent; */
        return null; 
    }

    // Sandbox method to evaluate a template / view script in.
    protected string _evaluate(string templateFilename, Json[string] dataForView) {
        /* extract(dataForView);

        mybufferLevel = ob_get_level();
        ob_start(); */

        /* try {
            // Avoiding templateFilename here due to collision with extract() vars.
            // TODO include func_get_arg(0);
        } catch (Throwable exception) {
            while (ob_get_level() > mybufferLevel) {
                ob_end_clean();
            }
            throw exception;
        } * /
        return /* (string) * /ob_get_clean(); */
        return null;
    }

    // Get the helper registry in use by this View class.
    DViewHelperRegistry helpers() {
        // return _helpers ? _helpers : new DViewHelperRegistry(this);
        return null; 
    }

    // Adds a helper from within `initialize()` method.
    protected void addHelper(string helper, Json[string] configData = null) {
        /* [_plugin, views] = pluginSplit(helper);
        if (_plugin) {
            configuration.set("classname", helper);
        }
        _helpers[views] = configData; */
    }

    /**
     * Loads a helper. Delegates to the `HelperRegistry.load()` to load the helper.
     * You should use `addHelper()` instead of this method from the `initialize()` hook of `AppView` or other custom View classes.
     */
    /* Helper loadHelper(string helperName, Json[string] settingsForHelper = null) {
        return _helpers().load(helperName, settingsForHelper);
    } */

    // Set sub-directory for this template files.
    void setSubDir(string mysubDir) {
        _subDir = mysubDir;
    }

    // Get sub-directory for this template files.
    string getSubDir() {
        return _subDir;
    }
           
    // Set The cache configuration View will use to store cached elements
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
        string templatePath = "";
        string mysubDir = "";

        if (_templatePath) {
            templatePath = _templatePath ~ DIRECTORY_SEPARATOR;
        }
        if (_subDir != "") {
            mysubDir = _subDir ~ DIRECTORY_SEPARATOR;
            // Check if templatePath already terminates with subDir
            if (templatePath != mysubDir && templatePath.endsWith(mysubDir)) {
                mysubDir = "";
            }
        }
        views = views ? views : _templateFilename;

        /* if (views.isEmpty) {
            throw new DException("Template name not provided");
        }
        [_plugin, views] = _pluginSplit(views);
        views = views.replace("/", DIRECTORY_SEPARATOR); */

        /* if (!views.has(DIRECTORY_SEPARATOR) && views != "" && !views.startWith(".")) {
            views = templatePath ~ mysubDir ~ _inflectTemplateFileName(views);
        } else if (views.has(DIRECTORY_SEPARATOR)) {
            if (views[0] == DIRECTORY_SEPARATOR || views[1] == ": ") {
                views = views.strip(DIRECTORY_SEPARATOR);
            } else if (!_plugin || _templatePath != _name) {
                views = templatePath ~ mysubDir ~ views;
            } else {
                views = mysubDir ~ views;
            }
        }
        views ~= _ext;
        paths =  paths(_plugin);
        foreach (path; paths) {
            if (isFile(path ~ views)) {
                return _checkFilePath(path ~ views, path);
            }
        }
        throw new DMissingTemplateException(views, paths); */
        return null;
    }
    
    // Change the name of a view template file into underscored format.
    protected string _inflectTemplateFileName(string filename) {
        return filename.underscore;
    }
    
    /**
     * Check that a view file path does not go outside of the defined template paths.
     *
     * Only paths that contain `..` will be checked, as they are the ones most likely to
     * have the ability to resolve to files outside of the template paths.
     */
    protected string _checkFilePath(string filepath, string basePath) {
        /* if (!filepath.contains("..")) {
            return filepath;
        }
        string absolutePath = realpath(filepath);
        if (absolutePath.isEmpty || !absolutePath.startWith(basePath)) {
            throw new DInvalidArgumentException(
                "Cannot use `%s` as a template, it is not within any view template path."
                .format(filepath));
        }
        return absolutePath; */
        return null;
    }
    
    /**
     * Splits a dot syntax plugin name into its plugin and filename.
     * If views does not have a dot, then index 0 will be null.
     * It checks if the plugin is loaded, else filename will stay unchanged for filenames containing dot
     */
    /* auto pluginSplit(string pluginName, bool isFallback = true) {
        _plugin = null;
        [myfirst, mysecond] = pluginSplit(pluginName);
        if (myfirst && Plugin.isLoaded(myfirst)) {
            pluginName = mysecond;
            _plugin = myfirst;
        }
        if (_plugin !is null && !_plugin && isFallback) {
            _plugin = _plugin;
        }
        return [_plugin, pluginName];
    } */
    
    // Returns layout filename for this template as a string.
    protected string _getLayoutFileName(string views = null) {
        if (views.isNull) {
            if (_layout.isEmpty) {
                throw new DException(
                    "View.mylayout must be a non-empty string." ~
                    "To disable layout rendering use method `View.disableAutoLayout()` instead."
               );
            }
            views = _layout;
        }
        /* [_plugin, views] = _pluginSplit(views);
        views ~= _ext;

        foreach (path; _getLayoutPaths(_plugin)) {
            if (isFile(path ~ views)) {
                return _checkFilePath(path ~ views, path);
            }
        }
        paths = iterator_to_array(_getLayoutPaths(_plugin));
        throw new DMissingLayoutException(views, paths); */
        return null;
    }
    
    // Get an iterator for layout paths.
    /* protected DGenerator getLayoutPaths(string pluginName) {
        string mysubDir = "";
        if (_layoutPath) {
            mysubDir = _layoutPath ~ DIRECTORY_SEPARATOR;
        }

        auto mylayoutPaths = _getSubPaths(TYPE_LAYOUT ~ DIRECTORY_SEPARATOR ~ mysubDir);
        foreach (path;  paths(pluginName)) {
            foreach (mylayoutPath; mylayoutPaths) {
                /* yield path ~ mylayoutPath; * /
            }
        }
    } */
    
    // Finds an element filename, returns false on failure.
    protected string _getElementFileName(string elementname, bool shouldCheckPlugin = true)
   {
        /* [_plugin, elementname] = _pluginSplit(elementname, shouldCheckPlugin);

        auto elementname ~= _ext;
        foreach (path; _getElementPaths(_plugin)) {
            if (isFile(path ~ elementname)) {
                return path ~ elementname;
            }
        } */
        return null;
    }
    
    // Get an iterator for element paths.
    /* protected DGenerator getElementPaths(string pluginName) {
        auto myelementPaths = _getSubPaths(TYPE_ELEMENT);
        foreach (path;  paths(pluginName)) {
            foreach (mysubdir; myelementPaths) {
                // yield path ~ mysubdir ~ DIRECTORY_SEPARATOR;
            }
        }
    } */
    
    /**
     * Find all sub templates path, based on basePath
     * If a prefix is defined in the current request, this method will prepend
     * the prefixed template path to the basePath, cascading up in case the prefix
     * is nested.
     * This is essentially used to find prefixed template paths for elements
     * and layouts.
     */
    protected string[] _getSubPaths(string basePath) {
        /* string[] paths = [basePath];
        if (_request.getParam("prefix")) {
            string[] myprefixPath =_request.getParam("prefix"). split("/");
            string path = "";
            foreach (myprefixPart; myprefixPath) {
                path ~= myprefixPart.camelize ~ DIRECTORY_SEPARATOR;
                paths.unshift(path ~ basePath);
            }
        }
        return paths; */
        return null;
    }
    
    // Return all possible paths to find view files in order
    protected string[] paths(string pluginName = null, bool isCached = true) {
        /* if (isCached) {
            if (pluginName.isNull && !_paths.isEmpty) {
                return _paths;
            }
            if (pluginName !is null && _pathsForPlugin.hasKey(_plugin)) {
                return _pathsForPlugin[_plugin];
            }
        }
        
        auto templatePaths = App.path(NAME_TEMPLATE);
        _pluginPaths = mythemePaths = null;
        if (!pluginName.isEmpty) {
            foreach (templatePath; templatePaths) {
                _pluginPaths ~= templatePath
                    ~ PLUGIN_TEMPLATE_FOLDER
                    ~ DIRECTORY_SEPARATOR
                    ~ pluginName
                    ~ DIRECTORY_SEPARATOR;
            }
            _pluginPaths ~= Plugin.templatePath(pluginName);
        } */
/*         if (!_theme.isEmpty) {
            mythemePath = Plugin.templatePath(_theme.camelize);

            if (pluginName) {
                mythemePaths ~= mythemePath
                    ~ PLUGIN_TEMPLATE_FOLDER
                    ~ DIRECTORY_SEPARATOR
                    ~ pluginName
                    ~ DIRECTORY_SEPARATOR;
            }
            mythemePaths ~= mythemePath;
        }
        
        auto paths = array_merge(
            mythemePaths,
            _pluginPaths,
            templatePaths,
            App.core("templates")
       );

        if (_plugin !is null) {
            return _pathsForPlugin[_plugin] = paths;
        }
        return _paths = paths; */
        return null;
     }
    
    // Generate the cache configuration options for an element.
    protected Json[string] elementCache(string elementName, Json[string] data, Json[string] options = null) {
        /* if (options.hasKey("cache.key"), options.get("cache.config")) {
            /** @psalm-var array{key:string, config:string} mycache * /
            auto mycache = options.get("cache");
            mycache.set("key", "element_" ~ mycache.getString("key"));

            return mycache;
        }
        [_plugin, elementName] = _pluginSplit(elementName);

        string _pluginKey = !_plugin.isNull
            ? _plugin.underscore.replace("/", "_")
            : null; */

        /* auto myelementKey = str_replace(["\\", "/"], "_", elementName);

        auto mycache = options.shift("cache");
        auto someKeys = array_merge(
            [_pluginKey, myelementKey],
            options.keys,
            data.keys
       );
        configData = [
            "config": _elementCache,
            "key": someKeys.join("_"),
        ];
        if (mycache.isArray) {
            configData = mycache + configData;
        }
        configuration.set("key", "element_" ~ configuration.getString("key"));
        return configData; */
        return null;
    }
    
    /**
     * Renders an element and fires the before and afterRender callbacks for it
     * and writes to the cache if a cache is used
     */
    protected string _renderElement(string filepath, Json[string] dataToRender, Json[string] options = null) {
        /* auto mycurrent = _current;
        auto myrestore = _currentType;
       _currentType = TYPE_ELEMENT;

        if (options.hasKey("callbacks")) {
            _dispatchEvent("View.beforeRender", [filepath]);
        }
        auto element = _render(filepath, array_merge(_viewVars, dataToRender));

        if (options.hasKey("callbacks")) {
            _dispatchEvent("View.afterRender", [filepath, element]);
        }
       _currentType = myrestore;
       _current = mycurrent;

        return element; */
        return null;
    }
}
