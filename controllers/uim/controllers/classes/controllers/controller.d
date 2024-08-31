module uim.controllers.classes.controllers.controller;

import uim.controllers;

@safe:

/**
 - Application controller class for organization of business logic.
 - Provides basic functionality, such as rendering views inside layouts,
 - automatic model availability, redirection, callbacks, and more.
 *
 * Controllers should provide a number of 'action' methods. These are public
 * methods on a controller that are not inherited from `Controller`.
 * Each action serves as an endpoint for performing a specific action on a
 * resource or collection of resources. For example adding or editing a new
 * object, or listing a set of objects.
 *
 * You can access request parameters, using `getRequest()`. The request object
 * contains all the POST, GET and FILES that were part of the request.
 *
 * After performing the required action, controllers are responsible for
 * creating a response. This usually takes the form of a generated `View`, or
 * possibly a redirection to another URL. In either case `getResponse()`
 * allows you to manipulate all aspects of the response.
 *
 * Controllers are created based on request parameters and
 * routing. By default controllers and actions use conventional names.
 * For example `/posts/index` maps to `PostsController.index()`. You can re-map
 * URLs using Router.connect() or RouteBuilder.connect().
 *
 * ### Life cycle callbacks
 *
 * UIM fires a number of life cycle callbacks during each request.
 * By implementing a method you can receive the related events. The available
 * callbacks are:
 *
 * - `beforeFilter(IEvent event)`
 * Called before each action. This is a good place to do general logic that
 * applies to all actions.
 * - `beforeRender(IEvent event)`
 * Called before the view is rendered.
 * - `beforeRedirect(IEvent event, url, IResponse response)`
 *  Called before a redirect is done.
 * - `afterFilter(IEvent event)`
 * Called after each action is complete and after the view is rendered.
 *
 * @property \UIM\Controller\Component\FlashComponent flash
 * @property \UIM\Controller\Component\FormProtectionComponent formProtection
 * @property \UIM\Controller\Component\CheckHttpCacheComponent checkHttpCache
 * @implements \UIM\Event\IEventDispatcher<\UIM\Controller\Controller>
 */
class DController : UIMObject, IController { // IEventListener, IEventDispatcher {    
    mixin(ControllerThis!(""));

    // @use \UIM\Event\EventDispatcherTrait<\UIM\Core\IConsoleApplication>
    mixin TEventDispatcher;
    // mixin TLocatorAware;
    mixin TLog;
    mixin TViewVars;

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    IView[] views() {
        return null; 
    }

    IController addView(IView newView) {
        return null; 
    }

    IController orderViews()  {
        return null; 
    }

    IResponse response(Json[string] options = null) {
        return null; 
    }
    /**
     * The name of this controller. Controller names are plural, named after the model they manipulate.
     * Set automatically using conventions in Controller.__construct().
     */
    mixin(TProperty!("string", "pluginName"));
    // An instance of a IResponse object that contains information about the impending response
    mixin(TProperty!("IResponse", "response"));

    // View classes for content negotiation.
    protected string[] _viewClasses;

    /**
     * An instance of a \UIM\Http\ServerRequest object that contains information about the current request.
     * This object contains all the information about a request and several methods for reading
     * additional information about the request.
     */
    protected IServerRequest _serverRequest;

    /**
     * Pagination settings.
     *
     * When calling paginate() these settings will be merged with the configuration
     * you provide. Possible keys:
     *
     * - `maxLimit` - The maximum limit users can choose to view. Defaults to 100
     * - `limit` - The initial number of items per page. Defaults to 20.
     * - `page` - The starting page, defaults to 1.
     * - `allowedParameters` - A list of parameters users are allowed to set using request
     * parameters. Modifying this list will allow users to have more influence
     * over pagination, be careful with what you permit.
     * - `classname` - The paginator class to use. Defaults to `UIM\Datasource\Paging\NumericPaginator.classname`.
     */
    protected Json[string] _paginate;

    // Set to true to automatically render the view after action logic.
    protected bool _autoRender = true;

    /**
     * Instance of ComponentRegistry used to create Components
     *
     * @var \UIM\Controller\ComponentRegistry|null
     */
    protected DComponentRegistry _components = null;


// Gets the request instance.
    @property IServerRequest request() {
        // return _request;
        return null; 
    }

    /**
     * Sets the request objects and configures a number of controller properties
     * based on the contents of the request. Controller acts as a proxy for certain View variables
     * which must also be updated here. The properties that get set are:
     *
     * - this.request - To the  request parameter

     */
    void setRequest(IServerRequest serverRequest) {
        /* _request = serverRequest;
        _pluginName = serverRequest.getParam("plugin"); */
    }
    
    /**
     * Middlewares list.
     * @psalm-var array<int, array{middleware:\Psr\Http\Server\IMiddleware|\/*Closure|* / string, options:array{only?: string[], except?: string[]}}>
     */
    protected Json[string] _middlewares = null;

    /**
     .
     *
     * Sets a number of properties based on conventions if they are empty. To override the
     * conventions UIM uses you can define properties in your class declaration.
     * Params:
     * \UIM\Http\ServerRequest serverRequest Request object for this controller.
     * but expect that features that use the request parameters will not work.
     */
    this(
        IServerRequest serverRequest,
        string nameToOverride = null,
        IEventManager eventManager = null,
   ) {
        /* if (nameToOverride) {
            name(nameToOverride);
        } else if (_name is null) {
            auto controller = request.getParam("controller");
            if (controller) {
                _name = controller;
            }
        }
        if (_name !is null)) {
            [, name] = namespaceSplit(class);
            _name = subString(nameToOverride, 0, -10);
        }
        setRequest(request);
        _response = new IResponse();

        if (!eventManager.isNull) {
            setEventManager(eventManager);
        }
        if (_defaultTable.isNull) {
            _pluginName = _request.getParam("plugin");
            aTableAlias = (_pluginName ? _pluginName ~ "." : "") ~ _name;
            _defaultTable = aTableAlias;
        }
        this.initialize();

        getEventManager().on(this); */
    }
    
    
    // Get the component registry for this controller.
    DComponentRegistry components() {
        /* return _components ??= new DComponentRegistry(this); */
        return null; 
    }
    
    /**
     * Add a component to the controller`s registry.
     *
     * After loading a component it will be be accessible as a property through Controller.__get().
     * For example:
     *
     * ```
     * this.loadComponent("Authentication.Authentication");
     * ```
     *
     * Will result in a `this.Authentication` being a reference to that component.
     * Params:
     * configData - The config for the component.
     */
    DComponent loadComponent(string name, Json[string] configData = null) {
        // return _components().load(componentName, configData);
        return null;
    }
    
    //  Magic accessor for the default table.
    ITable __get(string propertyName) {
        // if (!_defaultTable.isEmpty) {
/*             if (_defaultTable.contains("\\")) {
                 classname = App.shortName(_defaultTable, "Model/Table", "Table");
            } else {
                [,  classname] = pluginSplit(_defaultTable, true);
            }

            if (classname == propertyName) {
                return _fetchTable();
            }
 */        // }
/*         if (this.components().has(propertyName)) {
            /** @var \UIM\Controller\Component   * /
            return _components().get(propertyName);
        }
 */
        /** @var array<int, Json[string]> trace */
        /* auto trace = debug_backtrace();
        auto someParts = classname.split("\\");
        trigger_error(
            "Undefined property `%s.$%s` in `%s` on line %s"
                .format(someParts.pop(),
                    propertyName,
                    trace[0]["file"],
                    trace[0]["line"]
               ),
                ERRORS.USER_NOTICE
           ); */

        return null;
    }


    // Returns true if an action should be rendered automatically.
    bool isAutoRenderEnabled() {
        return _autoRender;
    }

    // Enable automatic action rendering.
    void enableAutoRender() {
        _autoRender = true;
    }

    // Disable automatic action rendering.
    void disableAutoRender() {
        _autoRender = false;
    }
    
    // Get the closure for action to be invoked by ControllerFactory.
    IClosure getAction() {
/*         auto request = this.request;
        auto action = request.getParam("action"); */

        /* if (!this.isAction(action)) {
/*             throw new DMissingActionException([
                "controller": _name ~ "Controller",
                "action": request.getParam("action"),
                "prefix": request.getParam("prefix") ? : "",
                "plugin": request.getParam("plugin"),
            ]);
         } */
        // return _action(...);
        return null; 
    }
    
    // Dispatches the controller action.
    void invokeAction(IClosure action, Json[string] argumentsForAction) {
/*         auto result = action(...argumentsForAction);
        if (!result.isNull) {
            assert(
                cast(IResponse)result,
                    "Controller actions can only return IResponse instance or null. Got %s instead."
                    .format(get_debug_type(result)
               )
           );
        } else if (this.isAutoRenderEnabled()) {
            result = this.render();
        }
        if (result) {
            _response = result;
        }
 */    }
    
    // Register middleware for the controller.
    void middleware(IMiddleware middlewareToRegister, Json[string] options = null) {
        // Valid options:
        // * - `only`: (string[]) Only run the middleware for specified actions.
        // * - `except`: (string[]) Run the middleware for all actions except the specified ones.
        // TODO
    }
    void middleware(IClosure amiddleware, Json[string] options = null) {
        // TODO
    }
    void middleware(string amiddleware, Json[string] options = null) {
/*         _middlewares ~= [
            "middleware": middleware,
            "options": options,
        ];
 */    }

    // Get middleware to be applied for this controller.
    Json[string] getMiddlewares() {
/*         auto matching = null;
        auto requestAction = _request.getParam("action");

        foreach (middleware, _middlewares) {
            auto middlewareOptions = options = middleware["options"];
            if (!middlewareOptions.isEmpty("only")) {
                if (middlewareOptions.getArray("only").has(requestAction)) {
                     matching ~= middleware.get("middleware");
                }
                continue;
            }
            if (
                !middlewareOptions.isEmpty("except") &&
                middlewareOptions.getArray("except").has(requestAction)
           ) {
                continue;
            }
             matching ~= middleware.get("middleware");
        }
        return matching; */
        return null; 
    }
    
    /**
     * Returns a list of all events that will fire in the controller during its lifecycle.
     * You can override this auto to add your own listener callbacks
     */
    IEvent[] implementedEvents() {
       /*  return [
            "Controller.initialize": "beforeFilter",
            "Controller.beforeRender": "beforeRender",
            "Controller.beforeRedirect": "beforeRedirect",
            "Controller.shutdown": "afterFilter",
        ]; */
        return null; 
    }
    
    /**
     * Perform the startup process for this controller.
     * Fire the Components and Controller callbacks in the correct order.
     *
     * - Initializes components, which fires their `initialize` callback
     * - Calls the controller `beforeFilter`.
     * - triggers Component `startup` methods.
     */
    IResponse startupProcess() {
       /*  auto result = dispatchEvent("Controller.initialize").getResult();
        if (cast(IResponse)result) { return result; }

        result = dispatchEvent("Controller.startup").getResult();
        if (cast(IResponse)result) { return result; } */

        return null;
    }
    
    /**
     * Perform the various shutdown processes for this controller.
     * Fire the Components and Controller callbacks in the correct order.
     *
     * - triggers the component `shutdown` callback.
     * - calls the Controller`s `afterFilter` method.
     */
    IResponse shutdownProcess() {
/*         auto result = dispatchEvent("Controller.shutdown").getResult();
        if (cast(IResponse)result) {
            return result;
        }
 */        return null;
    }
    
    /**
     * Redirects to given url, after turning off this.autoRender.
     * Params:
     * \Psr\Http\Message\IUri|string[] aurl A string, array-based URL or IUri instance.
     */
    IResponse redirect(/* IUri */string[] url, int httpStatusCode = 302) {
/*         _autoRender = false;

        if (httpStatusCode < 300 || httpStatusCode > 399) {
            throw new DInvalidArgumentException(
                "Invalid status code `%s`. It should be within the range " ~
                    "`300` - `399` for redirect responses.".format(httpStatusCode)
           );
        }
        _response = _response.withStatus(httpStatusCode);
        
        auto event = dispatchEvent("Controller.beforeRedirect", [url, _response]);
        auto result = event.getResult();
        if (cast(IResponse)result) {
            return _response = result;
        }

        if (event.isStopped()) {
            return null;
        }

        response = _response;
        if (!response.headerLine("Location")) {
            response = response.withLocation(Router.url(url, true));
        }
        return _response = response; */
        return null; 
    }
    
    /**
     * Instantiates the correct view class, hands it its data, and uses it to render the view output.
     * Params:
     * string template Template to use for rendering
     * returns A response object containing the rendered view.
     */
    IResponse render(string templateName = null, string layoutName = null) {
/*         auto builder = viewBuilder();
        if (! builder.getTemplatePath()) {
             builder.setTemplatePath(_templatePath());
        }
        _autoRender = false;

        if (templateName) {
             builder.templateName(templateName);
        }
        if (layoutName) {
             builder.layout(layoutName);
        }
        event = dispatchEvent("Controller.beforeRender");
        if (cast(IResponse)event.getResult()) {
            return event.getResult();
        }
        if (event.isStopped()) {
            return _response;
        }
        if (builder.templateName().isNull) {
             builder.setTemplate(_request.getParam("action"));
        }
         viewClass = this.chooseViewClass();
         view = this.createView(viewClass);

        contents = view.render();
        response = view.getResponse().withStringBody(contents);

        return _setResponse(response).response; */
        return null;
    }
    
    /**
     * Get the View classes this controller can perform content negotiation with.
     *
     * Each view class must implement the `getContentType()` hook method
     * to participate in negotiation.
     */
    string[] viewClasses() {
        return _viewClasses;
    }
    
    /**
     * Add View classes this controller can perform content negotiation with.
     *
     * Each view class must implement the `getContentType()` hook method
     * to participate in negotiation.
     */
    void setViewClasses(Json[string] viewClasses) {
        // _viewClasses = _viewClasses.set(viewClasses);
    }
    
    /**
     * Use the view classes defined on this controller to view
     * selection based on content-type negotiation.
     */
    protected string chooseViewClass() {
        /* auto possibleViewClasses = this.viewClasses();
        if (possibleViewClasses.isEmpty) {
            return null;
        }
        // Controller or component has already made a view class decision.
        // That decision should overwrite the framework behavior.
        if (!viewBuilder().getclassname().isNull) {
            return null;
        }

        auto typeMap = null;
        foreach (classname; possibleViewClasses) {
             viewContentType = classname.contentType();
            if (viewContentType && !typeMap.hasKey(viewContentType)) {
                typeMap[viewContentType] = classname;
            }
        }
         request = getRequest(); */

        // Prefer the _ext route parameter if it is defined.
        // ext = request.getParam("_ext");
        // if (ext) {
/*             auto extTypes = /* (array) * /(_response.getMimeType(ext) ?: []);
            extTypes.each!((extType) {
                if (typeMap.hasKey(extTypes)) {
                    return typeMap[extType];
                }
            });
            throw new DNotFoundException("View class for `%s` extension not found".format(ext));
 */       // }
        // Use accept header based negotiation.
        /* auto contentType = new DContentTypeNegotiation();
        if(auto preferredType = contentType.preferredType(request, typeMap.keys)) {
            return typeMap[preferredType];
        }
        // Use the match-all view if available or null for no decision.
        return typeMap[DView.TYPE_MATCH_ALL] ?? null; */
        return null;
    }

    // Get the templatePath based on controller name and request prefix.
    protected string _templatePath() {
        string templatePath = _name;
/*         if (_request.getParam("prefix")) {
            prefixes = _request.getParam("prefix").split("/").camelize;
            templatePath = prefixes.join(DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR ~ templatePath;
        }
        return templatePath;
 */    return null; 
 }
    
    /**
     * Returns the referring URL for this request.
     * Params:
     * string[] default Default URL to use if HTTP_REFERER cannot be read from headers
     * Careful with trusting external sources.
     * returns Referring URL
     */
    string referer(string[] defaultUrl /* = "/" */, bool isLocal = true) {
/*         auto referer = _request.referer(isLocal);
        if (!referer.isNull) {
            return referer;
        }
        auto url = Router.url(defaultUrl, !isLocal);
        auto  base = _request.getAttribute("base");
        if (isLocal &&  base && url.startsWith(base)) {
            url = subString(url,  base.length);

return url[0] != "/"
     ?"/" ~ url
: url;
        }
        return url; */
        return null; 
    }
    
    /**
     * Handles pagination of records in Table objects.
     *
     * Will load the referenced Table object, and have the paginator
     * paginate the query using the request date and settings defined in `this.paginate`.
     *
     * This method will also make the PaginatorHelper available in the view.
     * Params:
     * \UIM\Datasource\IRepository|\UIM\Datasource\IQuery|string  object Table to paginate
     * (e.g: Table instance, "TableName' or a Query object)
     */
    IPaginated paginate(
        /* IRepository|IQuery| */string  object = null,
        Json[string] settingsForPagination = null
   ) {
/*         if (!isObject(object)) {
             object = this.fetchTable(object);
        }
        settingsForPagination += this.paginate;

        auto paginatorclassname = App.classname(
            settingsForPagination.getString("classname", NumericPaginator.classname),
            "Datasource/Paging",
            "Paginator"
       );

        auto paginator = new paginatorclassname();
        settingsForPagination.removeKey("classname");

        try {
            results = paginator.paginate(
                 object,
                _request.queryArguments(),
                settingsForPagination
           );
        } catch (PageOutOfBoundsException exception) {
            throw new DNotFoundException(null, null, exception);
        }
        return results;
 */    
 return null; }
    
    /**
     * Method to check that an action is accessible from a URL.
     *
     * Override this method to change which controller methods can be reached.
     * The default implementation disallows access to all methods defined on UIM\Controller\Controller,
     * and allows all methods on all subclasses of this class.
     */
    bool isAction(string actionName) {
/*          baseClass = new DReflectionClass(classname);
        if (baseClass.hasMethod(actionName)) {
            return false;
        }
        try {
             method = new DReflectionMethod(this, actionName);
        } catch (ReflectionException) {
            return false;
        }
        return method.isPublic() &&  method.name == actionName;
 */ 
    return false;
     }
    
    /**
     * Called before the controller action. You can use this method to configure and customize components
     * or perform logic that needs to happen before each controller action.
     * Params:
     * \UIM\Event\IEvent<\UIM\Controller\Controller> event An Event instance
     */
    /* IResponse|null| */void beforeFilter(IEvent event) {
    }
    
    /**
     * Called after the controller action is run, but before the view is rendered. You can use this method
     * to perform logic or set view variables that are required on every request.
     */
    IResponse beforeRender(IEvent event) {
        return null; 
    }
    
    /**
     * The beforeRedirect method is invoked when the controller`s redirect method is called but before any
     * further action.
     *
     * If the event is stopped the controller will not continue on to redirect the request.
     * The url and status variables have same meaning as for the controller`s method.
     * You can set the event result to response instance or modify the redirect location
     * using controller`s response instance.
     */
    IResponse beforeRedirect(IEvent event, /* IUri */ string[] url, IResponse response) {
        return null; 
    }
    
    // Called after the controller action is run and rendered.
    IResponse afterFilter(IEvent event) {
        return null; 
    }
}
