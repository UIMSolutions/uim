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
 * You can access request parameters, using `this.getRequest()`. The request object
 * contains all the POST, GET and FILES that were part of the request.
 *
 * After performing the required action, controllers are responsible for
 * creating a response. This usually takes the form of a generated `View`, or
 * possibly a redirection to another URL. In either case `this.getResponse()`
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
 *  Called before each action. This is a good place to do general logic that
 *  applies to all actions.
 * - `beforeRender(IEvent event)`
 *  Called before the view is rendered.
 * - `beforeRedirect(IEvent event, url, Response response)`
 *   Called before a redirect is done.
 * - `afterFilter(IEvent event)`
 *  Called after each action is complete and after the view is rendered.
 *
 * @property \UIM\Controller\Component\FlashComponent flash
 * @property \UIM\Controller\Component\FormProtectionComponent formProtection
 * @property \UIM\Controller\Component\CheckHttpCacheComponent checkHttpCache
 * @link https://book.UIM.org/5/en/controllers.html
 * @implements \UIM\Event\IEventDispatcher<\UIM\Controller\Controller>
 */
class DController : IController { // IEventListener, IEventDispatcher {    
    mixin TConfigurable;
    // @use \UIM\Event\EventDispatcherTrait<\UIM\Core\IConsoleApplication>
    mixin TEventDispatcher;
    mixin TLocatorAware;
    mixin TLog;
    mixin TViewVars;

    this() {
        initialize;
    }

    this(IData[string] initData) {
        initialize(initData);
    }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    /**
     * The name of this controller. Controller names are plural, named after the model they manipulate.
     * Set automatically using conventions in Controller.__construct().
     */
    mixin(TProperty!("string", "name"));
    mixin(TProperty!("string", "pluginName"));
    // TODO mixin(TProperty!("Response", "response"));


    // View classes for content negotiation.
    protected string[] _viewClasses;

    /**
     * An instance of a \UIM\Http\ServerRequest object that contains information about the current request.
     * This object contains all the information about a request and several methods for reading
     * additional information about the request.
     * /
    protected IServerRequest serverRequest;

    /**
     * An instance of a Response object that contains information about the impending response
     *
     * @link https://book.UIM.org/5/en/controllers/request-response.html#response
     * /
    protected DResponse response;

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
     *  parameters. Modifying this list will allow users to have more influence
     *  over pagination, be careful with what you permit.
     * - `className` - The paginator class to use. Defaults to `UIM\Datasource\Paging\NumericPaginator.classname`.
     *
     * @see \UIM\Datasource\Paging\NumericPaginator
     * /
    protected IData[string] paginate;

    // Set to true to automatically render the view after action logic.
    protected bool autoRender = true;

    /**
     * Instance of ComponentRegistry used to create Components
     *
     * @var \UIM\Controller\ComponentRegistry|null
     * /
    protected DComponentRegistry _components = null;


// Gets the request instance.
    @property ServerRequest request() {
        return _request;
    }

    /**
     * Sets the request objects and configures a number of controller properties
     * based on the contents of the request. Controller acts as a proxy for certain View variables
     * which must also be updated here. The properties that get set are:
     *
     * - this.request - To the  request parameter
     * Params:
     * \UIM\Http\ServerRequest serverRequest Request instance.
     * /
    void setRequest(DServerRequest serverRequest) {
        _request = serverRequest;
        _pluginName = serverRequest.getParam("plugin");
    }
    
    /**
     * Middlewares list.
     *
     * @psalm-var array<int, array{middleware:\Psr\Http\Server\IMiddleware|\Closure|string, options:array{only?: string[], except?: string[]}}>
     * /
    protected array  middlewares = null;


    /**
     * Constructor.
     *
     * Sets a number of properties based on conventions if they are empty. To override the
     * conventions UIM uses you can define properties in your class declaration.
     * Params:
     * \UIM\Http\ServerRequest serverRequest Request object for this controller.
     *  but expect that features that use the request parameters will not work.
     * @param string|null name Override the name useful in testing when using mocks.
     * @param \UIM\Event\IEventManager|null eventManager The event manager. Defaults to a new instance.
     * /
    this(
        ServerRequest serverRequest,
        string aName = null,
        ?IEventManager eventManager = null,
    ) {
        if (aName !isNull) {
            this.name(aName);
        } elseif (!isSet(this.name)) {
            controller =  request.getParam("controller");
            if (controller) {
                this.name = controller;
            }
        }
        if (!isSet(this.name)) {
            [, name] = namespaceSplit(class);
            this.name = substr(name, 0, -10);
        }
        this.setRequest( request);
        this.response = new DResponse();

        if (eventManager !isNull) {
            this.setEventManager(eventManager);
        }
        if (this.defaultTable is null) {
            _pluginName = this.request.getParam("plugin");
            aTableAlias = (_pluginName ? _pluginName ~ "." : "") ~ this.name;
            this.defaultTable = aTableAlias;
        }
        this.initialize();

        this.getEventManager().on(this);
    }
    
    // Initialization hook method.
    bool initialize(IData[string] initData = null) {
    }
    
    // Get the component registry for this controller.
    ComponentRegistry components() {
        return _components ??= new DComponentRegistry(this);
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
     * /
    Component loadComponent(string componentName, IData[string] configData = null) {
        return this.components().load(componentName, configData);
    }
    
    //  Magic accessor for the default table.
    Table __get(string propertyName) {
        if (!this.defaultTable.isEmpty) {
            if (this.defaultTable.has("\\")) {
                 className = App.shortName(this.defaultTable, "Model/Table", "Table");
            } else {
                [,  className] = pluginSplit(this.defaultTable, true);
            }
            if (className == propertyName) {
                return this.fetchTable();
            }
        }
        if (this.components().has(propertyName)) {
            /** @var \UIM\Controller\Component   * /
            return this.components().get(propertyName);
        }
        /** @var array<int, IData[string]> trace * /
        trace = debug_backtrace();
        someParts = split("\\", class);
        trigger_error(
            "Undefined property `%s.$%s` in `%s` on line %s"
                .format(array_pop(someParts),
                    propertyName,
                    trace[0]["file"],
                    trace[0]["line"]
                ),
                E_USER_NOTICE
            );

        return null;
    }


    // Returns true if an action should be rendered automatically.
    bool isAutoRenderEnabled() {
        return this.autoRender;
    }

    // Enable automatic action rendering.
    void enableAutoRender() {
        this.autoRender = true;
    }

    // Disable automatic action rendering.
    void disableAutoRender() {
        this.autoRender = false;
    }
    

    // Get the closure for action to be invoked by ControllerFactory.
    Closure getAction() {
         request = this.request;
        action =  request.getParam("action");

        if (!this.isAction(action)) {
            throw new DMissingActionException([
                "controller": this.name ~ "Controller",
                "action":  request.getParam("action"),
                "prefix":  request.getParam("prefix") ?: "",
                "plugin":  request.getParam("plugin"),
            ]);
        }
        return this.action(...);
    }
    
    /**
     * Dispatches the controller action.
     * Params:
     * \Closure action The action closure.
     * @param array someArguments The arguments to be passed when invoking action.
     * /
    void invokeAction(Closure action, array someArguments) {
        result = action(...someArguments);
        if (result !isNull) {
            assert(
                cast(Response)result,
                    "Controller actions can only return Response instance or null. Got %s instead."
                    .format(get_debug_type(result)
                )
            );
        } elseif (this.isAutoRenderEnabled()) {
            result = this.render();
        }
        if (result) {
            this.response = result;
        }
    }
    
    /**
     * Register middleware for the controller.
     * Params:
     * \Psr\Http\Server\IMiddleware|\Closure|string amiddleware Middleware.
     * @param IData[string] options Valid options:
     * - `only`: (string[]) Only run the middleware for specified actions.
     * - `except`: (string[]) Run the middleware for all actions except the specified ones.
     * /
    void middleware(IMiddleware amiddleware, IData[string] options = null) {
        // TODO
    }
    void middleware(Closure amiddleware, IData[string] options = null) {
        // TODO
    }
    void middleware(string amiddleware, IData[string] options = null) {
        this.middlewares ~= [
            "middleware":  middleware,
            "options": options,
        ];
    }

    // Get middleware to be applied for this controller.
    array getMiddlewares() {
        auto  matching = null;
        auto requestAction = this.request.getParam("action");

        foreach (this.middlewares as  middleware) {
            options =  middleware["options"];
            if (!options["only"].isEmpty) {
                if (in_array(requestAction, (array)options["only"], true)) {
                     matching ~=  middleware["middleware"];
                }
                continue;
            }
            if (
                !empty(options["except"]) &&
                in_array(requestAction, (array)options["except"], true)
            ) {
                continue;
            }
             matching ~=  middleware["middleware"];
        }
        return  matching;
    }
    
    /**
     * Returns a list of all events that will fire in the controller during its lifecycle.
     * You can override this auto to add your own listener callbacks
     * /
    IEvent[] implementedEvents() {
        return [
            "Controller.initialize": "beforeFilter",
            "Controller.beforeRender": "beforeRender",
            "Controller.beforeRedirect": "beforeRedirect",
            "Controller.shutdown": "afterFilter",
        ];
    }
    
    /**
     * Perform the startup process for this controller.
     * Fire the Components and Controller callbacks in the correct order.
     *
     * - Initializes components, which fires their `initialize` callback
     * - Calls the controller `beforeFilter`.
     * - triggers Component `startup` methods.
     * /
    IResponse startupProcess() {
        result = this.dispatchEvent("Controller.initialize").getResult();
        if (cast(IResponse)result) { return result; }

        result = this.dispatchEvent("Controller.startup").getResult();
        if (cast(IResponse)result) { return result; }

        return null;
    }
    
    /**
     * Perform the various shutdown processes for this controller.
     * Fire the Components and Controller callbacks in the correct order.
     *
     * - triggers the component `shutdown` callback.
     * - calls the Controller`s `afterFilter` method.
     * /
    IResponse shutdownProcess() {
        result = this.dispatchEvent("Controller.shutdown").getResult();
        if (cast(IResponse)result) {
            return result;
        }
        return null;
    }
    
    /**
     * Redirects to given url, after turning off this.autoRender.
     * Params:
     * \Psr\Http\Message\IUri|string[] aurl A string, array-based URL or IUri instance.
     * @param int status HTTP status code. Defaults to `302`.
     * @link https://book.UIM.org/5/en/controllers.html#Controller.redirect
     * /
    Response redirect(IUri|string[] aurl, int status = 302) {
        this.autoRender = false;

        if (status < 300 || status > 399) {
            throw new DInvalidArgumentException(
                "Invalid status code `%s`. It should be within the range " ~
                    "`300` - `399` for redirect responses.".format(status)
            );
        }
        this.response = this.response.withStatus(status);
        
        auto event = this.dispatchEvent("Controller.beforeRedirect", [url, this.response]);
        auto result = event.getResult();
        if (cast(Response)result) {
            return this.response = result;
        }
        if (event.isStopped()) {
            return null;
        }
        response = this.response;

        if (!response.getHeaderLine("Location")) {
            response = response.withLocation(Router.url(url, true));
        }
        return this.response = response;
    }
    
    /**
     * Instantiates the correct view class, hands it its data, and uses it to render the view output.
     * Params:
     * string|null template Template to use for rendering
     * @param string|null  layout Layout to use
     * returns A response object containing the rendered view.
     * @link https://book.UIM.org/5/en/controllers.html#rendering-a-view
     * /
    Response render(string atemplate = null, string alayout = null) {
         builder = this.viewBuilder();
        if (! builder.getTemplatePath()) {
             builder.setTemplatePath(_templatePath());
        }
        this.autoRender = false;

        if (template !isNull) {
             builder.setTemplate(template);
        }
        if ( layout !isNull) {
             builder.setLayout( layout);
        }
        event = this.dispatchEvent("Controller.beforeRender");
        if (cast(Response)event.getResult()) {
            return event.getResult();
        }
        if (event.isStopped()) {
            return this.response;
        }
        if ( builder.getTemplate() is null) {
             builder.setTemplate(this.request.getParam("action"));
        }
         viewClass = this.chooseViewClass();
         view = this.createView( viewClass);

        contents =  view.render();
        response =  view.getResponse().withStringBody(contents);

        return this.setResponse(response).response;
    }
    
    /**
     * Get the View classes this controller can perform content negotiation with.
     *
     * Each view class must implement the `getContentType()` hook method
     * to participate in negotiation.
     *
     * @see UIM\Http\ContentTypeNegotiation
     * /
    string[] viewClasses() {
        return this.viewClasses;
    }
    
    /**
     * Add View classes this controller can perform content negotiation with.
     *
     * Each view class must implement the `getContentType()` hook method
     * to participate in negotiation.
     * Params:
     * array  viewClasses View classes list.
     * /
    void addViewClasses(array  viewClasses) {
        this.viewClasses = array_merge(this.viewClasses,  viewClasses);
    }
    
    /**
     * Use the view classes defined on this controller to view
     * selection based on content-type negotiation.
     * /
    protected string chooseViewClass() {
        auto possibleViewClasses = this.viewClasses();
        if (possibleViewClasses.isEmpty) {
            return null;
        }
        // Controller or component has already made a view class decision.
        // That decision should overwrite the framework behavior.
        if (!this.viewBuilder().getClassName() is null) {
            return null;
        }

        auto typeMap = null;
        foreach (className; possibleViewClasses) {
             viewContentType = className.contentType();
            if ( viewContentType && !typeMap.isSet( viewContentType)) {
                typeMap[ viewContentType] = className;
            }
        }
         request = this.getRequest();

        // Prefer the _ext route parameter if it is defined.
        ext =  request.getParam("_ext");
        if (ext) {
            auto extTypes = (array)(this.response.getMimeType(ext) ?: []);
            foreach (extType; extTypes) {
                if (typeMap.isSet(extTypes)) {
                    return typeMap[extType];
                }
            }
            throw new DNotFoundException("View class for `%s` extension not found".format(ext));
        }
        // Use accept header based negotiation.
        auto contentType = new DContentTypeNegotiation();
        if(auto preferredType = contentType.preferredType( request, typeMap.keys)) {
            return typeMap[preferredType];
        }
        // Use the match-all view if available or null for no decision.
        return typeMap[View.TYPE_MATCH_ALL] ?? null;
    }

    // Get the templatePath based on controller name and request prefix.
    protected string _templatePath() {
        string templatePath = this.name;
        if (this.request.getParam("prefix")) {
            prefixes = array_map(
                "UIM\Utility\Inflector.camelize",
                split("/", this.request.getParam("prefix"))
            );
            templatePath = prefixes.join(DIRECTORY_SEPARATOR) ~ DIRECTORY_SEPARATOR ~ templatePath;
        }
        return templatePath;
    }
    
    /**
     * Returns the referring URL for this request.
     * Params:
     * string[]  default Default URL to use if HTTP_REFERER cannot be read from headers
     * @param bool  local If false, do not restrict referring URLs to local server.
     *  Careful with trusting external sources.
     * returns Referring URL
     * /
    string referer(string[]  default = "/", bool  local = true) {
         referer = this.request.referer( local);
        if ( referer !isNull) {
            return  referer;
        }
        url = Router.url( default, ! local);
         base = this.request.getAttribute("base");
        if ( local &&  base && url.startsWith( base)) {
            url = substr(url,  base.length);
            if (url[0] != "/") {
                url = "/" ~ url;
            }
            return url;
        }
        return url;
    }
    
    /**
     * Handles pagination of records in Table objects.
     *
     * Will load the referenced Table object, and have the paginator
     * paginate the query using the request date and settings defined in `this.paginate`.
     *
     * This method will also make the PaginatorHelper available in the view.
     * Params:
     * \UIM\Datasource\IRepository|\UIM\Datasource\IQuery|string|null  object Table to paginate
     * (e.g: Table instance, "TableName' or a Query object)
     * /
    IPaginated paginate(
        IRepository|IQuery|string|null  object = null,
        IData[string] settingsForPagination = null
    ) {
        if (!isObject( object)) {
             object = this.fetchTable( object);
        }
        settingsForPagination += this.paginate;

        auto paginatorClassname = App.className(
            settingsForPagination["className"] ?? NumericPaginator.classname,
            "Datasource/Paging",
            "Paginator"
        );

        auto paginator = new paginatorClassname();
        settingsForPagination.remove("className");

        try {
            results = paginator.paginate(
                 object,
                this.request.getQueryParams(),
                settingsForPagination
            );
        } catch (PageOutOfBoundsException exception) {
            throw new DNotFoundException(null, null, exception);
        }
        return results;
    }
    
    /**
     * Method to check that an action is accessible from a URL.
     *
     * Override this method to change which controller methods can be reached.
     * The default implementation disallows access to all methods defined on UIM\Controller\Controller,
     * and allows all methods on all subclasses of this class.
     * Params:
     * string aaction The action to check.
     * /
    bool isAction(string actionName) {
         baseClass = new DReflectionClass(self.classname);
        if ( baseClass.hasMethod(actionName)) {
            return false;
        }
        try {
             method = new DReflectionMethod(this, actionName);
        } catch (ReflectionException) {
            return false;
        }
        return  method.isPublic() &&  method.name == actionName;
    }
    
    /**
     * Called before the controller action. You can use this method to configure and customize components
     * or perform logic that needs to happen before each controller action.
     * Params:
     * \UIM\Event\IEvent<\UIM\Controller\Controller> event An Event instance
     * /
    Response|null|void beforeFilter(IEvent event) {
    }
    
    /**
     * Called after the controller action is run, but before the view is rendered. You can use this method
     * to perform logic or set view variables that are required on every request.
     * Params:
     * \UIM\Event\IEvent<\UIM\Controller\Controller> event An Event instance
     * /
    Response beforeRender(IEvent event) {
    }
    
    /**
     * The beforeRedirect method is invoked when the controller`s redirect method is called but before any
     * further action.
     *
     * If the event is stopped the controller will not continue on to redirect the request.
     * The url and status variables have same meaning as for the controller`s method.
     * You can set the event result to response instance or modify the redirect location
     * using controller`s response instance.
     * Params:
     * \UIM\Event\IEvent<\UIM\Controller\Controller> event An Event instance
     * @param \Psr\Http\Message\IUri|string[] aurl A string or array-based URL pointing to another location within the app,
     *    or an absolute URL
     * /
    Response beforeRedirect(IEvent event, IUri|string[] aurl, Response response) {
        return null; 
    }
    
    /**
     * Called after the controller action is run and rendered.
     * /
    Response afterFilter(IEvent event) {
        return null; 
    } */
}
