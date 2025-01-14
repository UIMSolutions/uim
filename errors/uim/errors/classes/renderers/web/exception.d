/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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
    /**
     * Creates the controller to perform rendering on the error response.
     * Params:
     * \Throwable exception Exception.
     * instead of creating a new one.
     */
    /* this(Throwable exception, IServerRequest serverRequest = null) {
        _error = exception;
        _request = serverRequest;
        _controller = _getController();
    } */

    // Controller instance.
    protected IErrorController controller;

    // Template to render for {@link \UIM\Core\Exception\UIMException}
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
    /* protected IServerRequest serverRequest; */

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
     * Get the controller instance to handle the exception.
     * Override this method in subclasses to customize the controller used.
     * This method returns the built in `ErrorController` normally, or if an error is repeated
     * a bare controller will be used.
     */
    protected IErrorController _getController() {
        request = _request;
        routerRequest = Router.getRequest();
        // Fallback to the request in the router or make a new one from
        // _SERVER
        if (request.isNull) {
            request = routerRequest ? routerRequest : ServerRequestFactory.fromGlobals();
        }
        // If the current request doesn`t have routing data, but we
        // found a request in the router context copy the params over
        if (request.getParam("controller").isNull && routerRequest !is null) {
            request = request.withAttribute("params", routerRequest.getAttribute("params"));
        }
        try {
            params = request.getAttribute("params");
            params.set("controller", "Error");

            auto factory = new DControllerFactory(new DContainer());
            // Check including plugin + prefix
            auto classname = factory.controllerClass(request.withAttribute("params", params));
            if (!classname && !params.isEmpty("prefix") && !params.isEmpty("plugin")) {
                params.removeKey("prefix");
                // Fallback to only plugin
                classname = factory.controllerClass(request.withAttribute("params", params));
            }
            if (!classname) {
                // Fallback to app/core provided controller.
                classname = App.classname("Error", "Controller", "Controller");
            }
            assert(isSubclass_of(classname, Controller.classname));
            controller = new classname(request);
            controller.startupProcess();
        } catch (Throwable anException) {
        }

        return controller is null
            ? new DController(request) : controller;
    }

    // Clear output buffers so error pages display properly.
    protected void clearOutput() {
        if (isIn(UIM_SAPI, ["cli", "Ddbg"])) {
            return;
        }
        while (ob_get_level()) {
            ob_end_clean();
        }
    }

    // Renders the response for the exception.
    /* IResponse render() {
        /* auto exception = _error;
        auto code = getHttpCode(exception);
        auto method = methodName(exception);
        auto templateText = templateName(exception, method, code);
        clearOutput();

        if (hasMethod(this, method)) {
            return _customMethod(method, exception);
        }
        string message = errorMessage(exception, code);
        auto url = _controller.getRequest().getRequestTarget();

        auto response = _controller.getResponse();
        if (cast(HttpException) exception) {
            exception.getHeaders().byKeyValue
                .each!(nameValue => response = response.withHeader(nameValue.name, nameValue.value));
        }
        response = response.withStatus(code);

        auto exceptions = [exception];
        auto previous = exception.getPrevious();
        while (!previous.isNull) {
            exceptions ~= previous;
            previous = previous.getPrevious();
        }
        
        auto viewVars = [
            "message": message,
            "url": htmlAttributeEscape(url),
            "error": exception,
            "exceptions": exceptions,
            "code": code,
        ];
        
        auto serialize = ["message", "url", "code"];
        auto isDebug = configuration.get("debug");
        if (isDebug) {
            trace =/*  (array) * / Debugger.formatTrace(exception.getTrace(), [
                    "format": "array",
                    "args": true.toJson,
                ]);
            origin = [
                "file": exception.getFile().ifEmpty("null"),
                "line": exception.getLine().ifEmpty("null"),
            ];
            // Traces don`t include the origin file/line.
            trace.unshift(origin);
            viewVars.set("trace", trace);
            viewVars += origin;
            serialize ~= "file";
            serialize ~= "line";
        }
        _controller.set(viewVars);
        _controller.viewBuilder().setOption("serialize", serialize);

        if (cast(UIMException) exception && isDebug) {
            _controller.set(exception.getAttributes());
        }
        _controller.setResponse(response);

        return _outputMessage(template); * / 
        return null;
    } */

    /**
     * Emit the response content
     * Params:
     * \Psr\Http\Message\IResponse|string aoutput The response to output.
     */
    void write(string outputText) {
        writeln(output);
    }

    void write(IResponse outputResponse) {
        auto emitter = new DResponseEmitter();
        emitter.emit(outputResponse);
    }

    // Render a custom error method/template.
    /* protected IResponse _customMethod(string methodName, Throwable exceptionToRender) {
        /*         auto result = this.{
            methodName
        }
        (exceptionToRender);
        _shutdown();
        if (isString(result)) {
            result = _controller.getResponse().withStringBody(result);
        }
        return result; * /
        return null;
    } */

    // Get method name
    override protected string methodName(Throwable exception) {
        /* [, baseClass] = namespaceSplit(exception.classname);

        if (baseClass.endsWith("Exception")) {
            baseClass = subString(baseClass, 0, -9);
        }
        // baseClass would be an empty string if the exception class is \Exception.
        method = baseClass is null ? "error500" : Inflector.variable(baseClass);

        return _method = method; */
        return null;
    }

    // Get error message.
    protected string errorMessage(Throwable exception, int errorCode) {
        /* string result = exception.message();

        if (
            !configuration.hasKey("debug") &&
            !(cast(HttpException) exception)
            ) {
            result = code < 500
                ? __d("uim", "Not Found") : __d("uim", "An Internal Error Has Occurred.");
        }
    }

    return result; */
        return null;
    }

    /**
     * Get template for rendering exception info.
     * Params:
     * \Throwable exception Exception instance.
     */
    protected string templateName(Throwable exception, string methodName, int errorCode) {
        /* if (cast(HttpException) exception || !configuration.hasKey("debug")) {
        return _template = errorCode < 500 ? "error400' : 'error500";
    }

    _template = cast(PDOException) exception
        ? "pdo_error" : methodName;

    return _template; */
        return null;
    }

    // Gets the appropriate http status code for exception.
    protected int getHttpCode(Throwable exception) {
        /* if (cast(HttpException) exception) {
            return exception.code();
        }
        return _exceptionHttpCodes[exception.classname] ?  ? 500; */
        return 0;
    }

    // Generate the response using the controller object.
    protected IResponse _outputMessage(string templateToRender) {
        /* try {
        _controller.render(templateToRender);

        return _shutdown();
    } catch (MissingTemplateException anException) {
        attributes = anException.getAttributes();
        if (
            cast(MissingLayoutException) anException ||
            attributes.getString("file").contains("error500")
            ) {
            return _outputMessageSafe("error500");
        }
        return _outputMessage("error500");
    } catch (MissingPluginException anException) {
        attributes = anException.getAttributes();
        if (attributes.getString("plugin") == _controller.pluginName) {
            _controller.setPlugin(null);
        }
        return _outputMessageSafe("error500");
    } catch (Throwable outer) {
        try {
            return _outputMessageSafe("error500");
        } catch (Throwable anInner) {
            throw outer;
        }
    } */
        return null;
    }

    /**
     * A safer way to render error messages, replaces all helpers, with basics
     * and doesn`t call component methods.
     * Params:
     * string atemplate The template to render.
     */
    protected IResponse _outputMessageSafe(string templateText) {
        auto builder = _controller.viewBuilder();
        builder
            .setHelpers([])
            .setLayoutPath("")
            .setTemplatePath("Error");

        auto view = _controller.createView("View");
        auto response = _controller.getResponse()
            .withType("html")
            .withStringBody(view.render(templateText, "error"));
        _controller.setResponse(response);

        return response;
    }

    /**
     * Run the shutdown events.
     * Triggers the afterFilter and afterDispatch events.
     */
    protected IResponse _shutdown() {
        _controller.dispatchEvent("Controller.shutdown");

        return _controller.getResponse();
    }

    /**
     * Returns an array that can be used to describe the internal state of this
     * object.
     */
    Json[string] debugInfo() {
        return super.debugInfo()
            .set("error", _error)
            .set("request", _request)
            .set("controller", _controller)
            .set("template", _template)
            .set("method", _method);
    }
}
