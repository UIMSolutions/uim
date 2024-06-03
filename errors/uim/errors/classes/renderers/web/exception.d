module uim.errors.classes.renderers.web.exception;

import uim.errors;

@safe:

/**
 * Web Exception Renderer.
 *
 * Captures and handles all unhandled exceptions. Displays helpful framework errors when debug is true.
 * When debug is false, WebExceptionRenderer will render 404 or 500 errors. If an uncaught exception is thrown
 * and it is a type that WebExceptionHandler does not know about it will be treated as a 500 error.
 *
 * ### Implementing application specific exception rendering
 *
 * You can implement application specific exception handling by creating a subclass of
 * WebExceptionRenderer and configure it to be the `exceptionRenderer` in config/error.d
 *
 * #### Using a subclass of WebExceptionRenderer
 *
 * Using a subclass of WebExceptionRenderer gives you full control over how Exceptions are rendered, you
 * can configure your class in your config/app.d.
 */
class DWebExceptionRenderer { // }: IExceptionRenderer {
    // Controller instance.
    protected IController controller;

    // Template to render for {@link \UIM\Core\Exception\DException}
    protected string atemplate = "";

    // The method corresponding to the Exception this object is for.
    protected string methodName = "";

    /**
     * The exception being handled.
     *
     * @var \Throwable
     */
    protected Throwable error;

    /**
     * If set, this will be request used to create the controller that will render
     * the error.
     *
     * @var \UIM\Http\ServerRequest|null
     */
    protected IServerRequest serverRequest;

    /**
     * Map of exceptions to http status codes.
     *
     * This can be customized for users that don`t want specific exceptions to throw 404 errors
     * or want their application exceptions to be automatically converted.
     *
     * @var array<string, int>
     * @psalm-var array<class-string<\Throwable>, int>
     */
    protected Json[string] exceptionHttpCodes = [
        // Controller exceptions
        InvalidParameterException.classname: 404,
        MissingActionException.classname: 404,
        // Datasource exceptions
        PageOutOfBoundsException.classname: 404,
        RecordNotFoundException.classname: 404,
        // Http exceptions
        MissingControllerException.classname: 404,
        // Routing exceptions
        MissingRouteException.classname: 404,
    ];

    /**
     * Creates the controller to perform rendering on the error response.
     * Params:
     * \Throwable exception Exception.
     * @param \UIM\Http\ServerRequest|null request The request if this is set it will be used
     * instead of creating a new one.
     */
    this(DThrowable exception, ServerRequest serverRequest = null) {
        _error = exception;
        _request = serverRequest;
        _controller = _getController();
    }
    
    /**
     * Get the controller instance to handle the exception.
     * Override this method in subclasses to customize the controller used.
     * This method returns the built in `ErrorController` normally, or if an error is repeated
     * a bare controller will be used.
     */
    protected IController _getController() {
        request = _request;
        routerRequest = Router.getRequest();
        // Fallback to the request in the router or make a new one from
        // _SERVER
        if (request.isNull) {
            request = routerRequest ?: ServerRequestFactory.fromGlobals();
        }
        // If the current request doesn`t have routing data, but we
        // found a request in the router context copy the params over
        if (request.getParam("controller").isNull && routerRequest !isNull) {
            request = request.withAttribute("params", routerRequest.getAttribute("params"));
        }
        try {
            params = request.getAttribute("params");
            params["controller"] = "Error";

            factory = new DControllerFactory(new DContainer());
            // Check including plugin + prefix
             className = factory.getControllerClass(request.withAttribute("params", params));

            if (!className && !params.isEmpty("prefix")) && !empty(params["plugin"])) {
                params.remove("prefix");
                // Fallback to only plugin
                 className = factory.getControllerClass(request.withAttribute("params", params));
            }
            if (!className) {
                // Fallback to app/core provided controller.
                className = App.className("Error", "Controller", "Controller");
            }
            assert(isSubclass_of(className, Controller.classname));
            controller = new className(request);
            controller.startupProcess();
        } catch (Throwable  anException) {
        }
        if (!isSet(controller)) {
            return new DController(request);
        }
        return controller;
    }
    
    // Clear output buffers so error pages display properly.
    protected void clearOutput() {
        if (in_array(UIM_SAPI, ["cli", "Ddbg"])) {
            return;
        }
        while (ob_get_level()) {
            ob_end_clean();
        }
    }
    
    // Renders the response for the exception.
    IResponse render() {
        auto exception = _error;
        auto code = getHttpCode(exception);
        auto method = methodName(exception);
        auto template = templateName(exception, method, code);
        clearOutput();

        if (method_exists(this, method)) {
            return _customMethod(method, exception);
        }
        message = errorMessage(exception, code);
        url = _controller.getRequest().getRequestTarget();
        
        auto response = _controller.getResponse();
        if (cast(HttpException)exception) {
            exception.getHeaders().byKeyValue
                .each!(nameValue => response = response.withHeader(nameValue.name, nameValue.value));
        }
        response = response.withStatus(code);

        exceptions = [exception];
        previous = exception.getPrevious();
        while (!previous.isNull) {
            exceptions ~= previous;
            previous = previous.getPrevious();
        }
        viewVars = [
            "message": message,
            "url": htmlAttributeEscape(url),
            "error": exception,
            "exceptions": exceptions,
            "code": code,
        ];
        serialize = ["message", "url", "code"];

         isDebug = configuration.get("debug");
        if (isDebug) {
            trace = (array)Debugger.formatTrace(exception.getTrace(), [
                "format": "array",
                "args": true.toJson,
            ]);
            origin = [
                "file": exception.getFile() ?: "null",
                "line": exception.getLine() ?: "null",
            ];
            // Traces don`t include the origin file/line.
            array_unshift(trace, origin);
            viewVars["trace"] = trace;
            viewVars += origin;
            serialize ~= "file";
            serialize ~= "line";
        }
        _controller.set(viewVars);
        _controller.viewBuilder().setOption("serialize", serialize);

        if (cast(DException)exception &&  isDebug) {
            _controller.set(exception.getAttributes());
        }
        _controller.setResponse(response);

        return _outputMessage(template);
    }
    
    /**
     * Emit the response content
     * Params:
     * \Psr\Http\Message\IResponse|string aoutput The response to output.
     */
    void write(IResponse|string aoutput) {
        if (isString(output)) {
            writeln(output;

            return;
        }
        emitter = new DResponseEmitter();
        emitter.emit(output);
    }
    
    // Render a custom error method/template.
    protected DResponse _customMethod(string methodName, Throwable exceptionToRender) {
        auto result = this.{methodName}(exceptionToRender);
       _shutdown();
        if (isString(result)) {
            result = _controller.getResponse().withStringBody(result);
        }
        return result;
    }
    
    // Get method name
    protected string methodName(Throwable exception) {
        [, baseClass] = namespaceSplit(exception.classname);

        if (baseClass.endsWith("Exception")) {
            baseClass = substr(baseClass, 0, -9);
        }
        // baseClass would be an empty string if the exception class is \Exception.
        method = baseClass == "" ? "error500" : Inflector.variable(baseClass);

        return _method = method;
    }
    
    // Get error message.
    protected string errorMessage(Throwable exception, int errorCode) {
        string result = exception.getMessage();

        if (
            !configuration.hasKey("debug") &&
            !(cast(HttpException)exception)
        ) {
            result = code < 500
                ? __d("uim", "Not Found")
                : __d("uim", "An Internal Error Has Occurred.");
            }
        }
        return result;
    }
    
    /**
     * Get template for rendering exception info.
     * Params:
     * \Throwable exception Exception instance.
     * @param string methodName Method name.
     */
    protected string templateName(Throwable exception, string methodName, int errorCode) {
        if (cast(HttpException)exception || !configuration.hasKey("debug")) {
            return _template = errorCode < 500 ? "error400' : 'error500";
        }
        if (cast(PDOException)exception) {
            return _template = "pdo_error";
        }
        return _template = method;
    }
    
    // Gets the appropriate http status code for exception.
    protected int getHttpCode(Throwable exception) {
        if (cast(HttpException)exception) {
            return exception.code();
        }
        return _exceptionHttpCodes[exception.classname] ?? 500;
    }
    
    // Generate the response using the controller object.
    protected DResponse _outputMessage(string templateToRender) {
        try {
            _controller.render(templateToRender);

            return _shutdown();
        } catch (MissingTemplateException  anException) {
            attributes = anException.getAttributes();
            if (
                cast(MissingLayoutException)anException ||
                attributes["file"].has("error500")
            ) {
                return _outputMessageSafe("error500");
            }
            return _outputMessage("error500");
        } catch (MissingPluginException  anException) {
            attributes = anException.getAttributes();
            if (attributes.hasKey("plugin"]) && attributes["plugin"] == _controller.pluginName) {
                _controller.setPlugin(null);
            }
            return _outputMessageSafe("error500");
        } catch (Throwable outer) {
            try {
                return _outputMessageSafe("error500");
            } catch (Throwable  anInner) {
                throw outer;
            }
        }
    }
    
    /**
     * A safer way to render error messages, replaces all helpers, with basics
     * and doesn`t call component methods.
     * Params:
     * string atemplate The template to render.
     */
    protected DResponse _outputMessageSafe(string atemplate) {
        builder = _controller.viewBuilder();
        builder
            .setHelpers([])
            .setLayoutPath("")
            .setTemplatePath("Error");
        view = _controller.createView("View");

        response = _controller.getResponse()
            .withType("html")
            .withStringBody(view.render(template, "error"));
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
    
    /**
     * Returns an array that can be used to describe the internal state of this
     * object.
     */
    Json[string] debugInfo() {
        return [
            "error": _error,
            "request": _request,
            "controller": _controller,
            "template": this.template,
            "method": this.method,
        ];
    } */
}
