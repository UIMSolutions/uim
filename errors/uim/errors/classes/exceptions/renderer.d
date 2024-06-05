/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.errors.errors.exceptionrendererx;

@safe:
import uim.errors;


/**
 * Exception Renderer.
 *
 * Captures and handles all unhandled exceptions. Displays helpful framework errors when debug is true.
 * When debug is false a ExceptionRenderer will render 404 or 500 errors. If an uncaught exception is thrown
 * and it is a type that ExceptionHandler does not know about it will be treated as a 500 error.
 *
 * ### Implementing application specific exception rendering
 *
 * You can implement application specific exception handling by creating a subclass of
 * ExceptionRenderer and configure it to be the `exceptionRenderer` in config/error.D
 *
 * #### Using a subclass of ExceptionRenderer
 *
 * Using a subclass of ExceptionRenderer gives you full control over how Exceptions are rendered, you
 * can configure your class in your config/app.D.
 */
class DExceptionRenderer { // }: IExceptionRenderer
    /**
     * The exception being handled.
     *
     * @var \Throwable
     */
    protected myError;

    /**
     * Controller instance.
     *
     * @var uim.controllers.Controller
     */
    protected controller;

    /**
     * Template to render for {@link uim.uim.Core\exceptions.DException}
     */
    protected string _template = "";

    /**
     * The method corresponding to the Exception this object is for.
     */
    protected string method = "";

    /**
     * If set, this will be request used to create the controller that will render
     * the error.
     *
     * @var uim.uim.http.ServerRequest|null
     */
    protected myRequest;

    /**
     * Map of exceptions to http status codes.
     *
     * This can be customized for users that don"t want specific exceptions to throw 404 errors
     * or want their application exceptions to be automatically converted.
     *
     * @var array<string, int>
     * @psalm-var array<class-string<\Throwable>, int>
     */
    protected myExceptionHttpCodes = [
        // Controller exceptions
        InvalidParameterException.class: 404,
        MissingActionException.class: 404,
        // Datasource exceptions
        PageOutOfBoundsException.class: 404,
        RecordNotFoundException.class: 404,
        // Http exceptions
        MissingControllerException.class: 404,
        // Routing exceptions
        MissingRouteException.class: 404,
    ];

    // Creates the controller to perform rendering on the error response.
    this(DThrowable exception, ServerRequest serverRequest = null) {
        this.error = exception;
        this.request = serverRequest;
        this.controller = _getController();
    }

    /**
     * Get the controller instance to handle the exception.
     * Override this method in subclasses to customize the controller used.
     * This method returns the built in `ErrorController` normally, or if an error is repeated
     * a bare controller will be used.
     */
    protected IController _getController() {
        myRequest = this.request;
        routerRequest = Router.getRequest();
        // Fallback to the request in the router or make a new one from
        // _SERVER
        if (myRequest.isNull) {
            myRequest = routerRequest ?: ServerRequestFactory.fromGlobals();
        }

        // If the current request doesn"t have routing data, but we
        // found a request in the router context copy the params over
        if (myRequest.getParam("controller").isNull && routerRequest  !is null) {
            myRequest = myRequest.withAttribute("params", routerRequest.getAttribute("params"));
        }

        myErrorOccured = false;
        try {
            myParams = myRequest.getAttribute("params");
            myParams["controller"] = "Error";

            factory = new DControllerFactory(new DContainer());
            myClass = factory.getControllerClass(myRequest.withAttribute("params", myParams));

            if (!myClass) {
                /** @var string myClass */
                myClass = App.className("Error", "Controller", "Controller");
            }

            /** @var uim.controllers.Controller controller */
            controller = new myClass(myRequest);
            controller.startupProcess();
        } catch (Throwable e) {
            myErrorOccured = true;
        }

        if (!isset(controller)) {
            return new DController(myRequest);
        }

        // Retry RequestHandler, as another aspect of startupProcess()
        // could have failed. Ignore any exceptions out of startup, as
        // there could be userland input data parsers.
        if (myErrorOccured && isset(controller.RequestHandler)) {
            try {
                myEvent = new DEvent("Controller.startup", controller);
                controller.RequestHandler.startup(myEvent);
            } catch (Throwable e) {
            }
        }

        return controller;
    }

    // Clear output buffers so error pages display properly.
    protected void clearOutput() {
        if (hasAllValues(D_SAPI, ["cli", "Ddbg"])) {
            return;
        }
        while (ob_get_level()) {
            ob_end_clean();
        }
    }

    // Renders the response for the exception.
    IResponse render() {
        exception = this.error;
        code = getHttpCode(exception);
        method = methodName(exception);
        myTemplate = templateName(exception, method, code);
        clearOutput();

        if (method_exists(this, method)) {
            return _customMethod(method, exception);
        }

        myMessage = errorMessage(exception, code);
        myUrl = _controller.getRequest().getRequestTarget();
        response = _controller.getResponse();

        if (cast(DException)exception ) {
            /** @psalm-suppress DeprecatedMethod */
            foreach (/* (array) */exception.responseHeader() as myKey: myValue) {
                response = response.withHeader(myKey, myValue);
            }
        }
        if (cast(HttpException)exception instanceof) {
            foreach (exception.getHeaders() as myName: myValue) {
                response = response.withHeader(myName, myValue);
            }
        }
        response = response.withStatus(code);

        viewVars = [
            "message": myMessage,
            "url": h(myUrl),
            "error": exception,
            "code": code,
        ];
        serialize = ["message", "url", "code"];

        isDebug = Configure.read("debug");
        if (isDebug) {
            trace = /* (array) */Debugger.formatTrace(exception.getTrace(), [
                "format": "array",
                "args": false,
            ]);
            origin = [
                "file": exception.getFile() ?: "null",
                "line": exception.getLine() ?: "null",
            ];
            // Traces don"t include the origin file/line.
            array_unshift(trace, origin);
            viewVars["trace"] = trace;
            viewVars += origin;
            serialize ~= "file";
            serialize ~= "line";
        }
        _controller.set(viewVars);
        _controller.viewBuilder().setOption("serialize", serialize);

        if (cast(DException)exception && isDebug) {
            _controller.set(exception.getAttributes());
        }
        _controller.setResponse(response);

        return _outputMessage(myTemplate);
    }

    // Render a custom error method/template.
    protected DResponse _customMethod(string methodName, Throwable exceptionToRender) {
        auto myResult = this.{methodName}(exceptionToRender);
        _shutdown();
        if (!myResult.isString) { return result; }

        return _controller.getResponse().withStringBody(myResult);
    }

    // Get method name
    protected string methodName(Throwable exception) {
        [, baseClass] = moduleSplit(get_class(exception));

        if (substr(baseClass, -9) == "Exception") {
            baseClass = substr(baseClass, 0, -9);
        }

        // baseClass would be an empty string if the exception class is \Exception.
        method = baseClass == "" ? "error500" : Inflector.variable(baseClass);

        return _method = method;
    }

    // Get error message.
    protected string errorMessage(Throwable exception, int errorCode) {
        myMessage = exception.getMessage();

        if (
            !Configure.read("debug") &&
            !(exception instanceof HttpException)
       ) {
            myMessage = errorCode < 500
                ? __d("uim", "Not Found") 
                __d("uim", "An Internal Error Has Occurred.");
        }

        return myMessage;
    }

    // Get template for rendering exception info.
    protected string templateName(Throwable exception, string methodName, int errorCode) {
        if (exception instanceof HttpException || !Configure.read("debug")) {
            return _template = errorCode < 500 ? "error400" : "error500";
        }

        if (exception instanceof PDOException) {
            return _template = "pdo_error";
        }

        return _template = methodName;
    }

    // Gets the appropriate http status code for exception.
    protected int getHttpCode(Throwable exception) {
        if (exception instanceof HttpException) {
            return exception.code();
        }

        return _exceptionHttpCodes[get_class(exception)] ?? 500;
    }

    // Generate the response using the controller object.
    protected DResponse _outputMessage(string templateToRender) {
        try {
            _controller.render(templateToRender);

            return _shutdown();
        } catch (MissingTemplateException e) {
            attributes = e.getAttributes();
            if (
                cast(MissingLayoutException)e ||
                indexOf(attributes["file"], "error500") != false
           ) {
                return _outputMessageSafe("error500");
            }

            return _outputMessage("error500");
        } catch (MissingPluginException e) {
            attributes = e.getAttributes();
            if (isset(attributes["plugin"]) && attributes["plugin"] == _controller.getPlugin()) {
                _controller.setPlugin(null);
            }

            return _outputMessageSafe("error500");
        } catch (Throwable e) {
            return _outputMessageSafe("error500");
        }
    }

    /**
     * A safer way to render error messages, replaces all helpers, with basics
     * and doesn"t call component methods.
     */
    protected DResponse _outputMessageSafe(string templateToRender) {
        auto myBuilder = _controller.viewBuilder();
        myBuilder
            .setHelpers([], false)
            .setLayoutPath("")
            .setTemplatePath("Error");
        view = _controller.createView("View");

        auto response = _controller.getResponse()
            .withType("html")
            .withStringBody(view.render(templateToRender, "error"));
        _controller.setResponse(response);

        return response;
    }

    /**
     * Run the shutdown events.
     *
     * Triggers the afterFilter and afterDispatch events.
     */
    protected DResponse _shutdown() {
        _controller.dispatchEvent("Controller.shutdown");

        return _controller.getResponse();
    }

    // Returns an array that can be used to describe the internal state of this object.
    Json[string] __debugInfo() {
        return [
            "error": this.error,
            "request": this.request,
            "controller": this.controller,
            "template": this.template,
            "method": this.method,
        ];
    } 
}
