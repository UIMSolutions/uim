/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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
  this() {
    initialize();
  }

  /* override  */
  bool initialize(Json[string] initData = null) {
    /* if (!super.initialize(initData)) {
            return false;
        } */

    _allMethods = [__traits(allMembers, DORMTable)];

    return true;
  }

  // The exception being handled.
  protected Throwable myError;

  // Controller instance.
  // protected IErrorController controller;

  // Template to render for {@link uim.Core\exceptions.UIMException}
  protected string _template = "";

  // The method corresponding to the Exception this object is for.
  protected string method = "";

  // If set, this will be request used to create the controller that will render the error.
  /* protected IServerRequest _request; */

  /**
     * Map of exceptions to http status codes.
     *
     * This can be customized for users that don"t want specific exceptions to throw 404 errors
     * or want their application exceptions to be automatically converted.
     *
     * @var array<string, int>
     * @psalm-var array<class-string<\Throwable>, int>
     */
  protected int[string] myExceptionHttpCodes; /*  = [
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
    ]; */

  // Creates the controller to perform rendering on the error response.
  /* this(Throwable exception, IServerRequest serverRequest = null) {
        _error = exception;
        _request = serverRequest;
        _controller = _getController();
    } */

  /**
     * Get the controller instance to handle the exception.
     * Override this method in subclasses to customize the controller used.
     * This method returns the built in `ErrorController` normally, or if an error is repeated
     * a bare controller will be used.
     */
  protected IErrorController _getController() {
    auto _request = this.request;
    auto routerRequest = Router.getRequest();
    // Fallback to the request in the router or make a new one from
    // _SERVER
    /*         if (_request.isNull) {
            _request = routerRequest ?: ServerRequestFactory.fromGlobals();
        }
 */
    // If the current request doesn"t have routing data, but we
    // found a request in the router context copy the params over
    /*         if (_request.getParam("controller").isNull && routerRequest  !is null) {
            _request = _request.withAttribute("params", routerRequest.getAttribute("params"));
        }

        auto myErrorOccured = false;
        try {
            auo params = _request.getAttribute("params");
            params["controller"] = "Error";

            auto factory = new DControllerFactory(new DContainer());
            auto myClass = factory.controllerClass(_request.withAttribute("params", params));

            if (!myClass) {
                /** @var string myClass * /
                myClass = App.classname("Error", "Controller", "Controller");
            }

            /** @var uim.controllers.Controller controller * /
            controller = new myClass(_request);
            controller.startupProcess();
        } catch (Throwable e) {
            myErrorOccured = true;
        }

        if (controller.isNull) {
            return new DController(_request);
        }

 */ // Retry RequestHandler, as another aspect of startupProcess()
    // could have failed. Ignore any exceptions out of startup, as
    // there could be userland input data parsers.
    if (myErrorOccured && controller.RequestHandler !is null) {
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
  // IResponse render() {
    /* auto exception = this.error;
        auto code = getHttpCode(exception);
        auto method = methodName(exception);
        auto myTemplate = templateName(exception, method, code);
        clearOutput();

        if (hasMethod(method)) {
            return _customMethod(method, exception);
        }

        auto myMessage = errorMessage(exception, code);
        auto myUrl = _controller.getRequest().getRequestTarget();
        auto response = _controller.getResponse(); */

    /* if (cast(UIMException) exception) {
            /** @psalm-suppress DeprecatedMethod */
    /* foreach (myKey, myValue; /* (array) * /exception.responseHeader()) {
                response = response.withHeader(myKey, myValue);
            } * /
        } */
    /* if (cast(HttpException)exception) {
            foreach (myName, myValue; exception.getHeaders()) {
                response = response.withHeader(myName, myValue);
            }
        } */
    /* auto response = response.withStatus(code);

    auto viewVars = [
      "message": myMessage,
      "url": h(myUrl),
      "error": exception,
      "code": code,
    ];
    serialize = ["message", "url", "code"];

    isDebug = Configure.read("debug");
    if (isDebug) {
      trace =  /* (array) * / Debugger.formatTrace(exception.getTrace(), [
            "format": "array",
            "args": false,
          ]);
      /*             origin = [
                "file": exception.getFile() ?: "null",
                "line": exception.getLine() ?: "null",
            ];
 */ // Traces don"t include the origin file/line.
      /*             trace.unshift(origin);
            viewVars.set("trace", trace);
            viewVars += origin;
            serialize ~= "file";
            serialize ~= "line";
 * /
    }
    _controller.set(viewVars);
    _controller.viewBuilder().setOption("serialize", serialize);

    if (cast(UIMException) exception && isDebug) {
      _controller.set(exception.getAttributes());
    }
    _controller.setResponse(response);

    return _outputMessage(myTemplate); */
  // }

  // Render a custom error method/template.
  /* protected IResponse _customMethod(string methodName, Throwable exceptionToRender) {
    /*         auto myResult = this.{methodName}(exceptionToRender);
        _shutdown();
        if (!myResult.isString) { return result; }

        return _controller.getResponse().withStringBody(myResult);
 * /
    return null;
  }
 */
  // Get method name
  protected string methodName(Throwable exception) {
    /*         [, baseClass] = moduleSplit(get_class(exception));

        if (subString(baseClass, -9) == "Exception") {
            baseClass = subString(baseClass, 0, -9);
        }

        // baseClass would be an empty string if the exception class is \Exception.
        method = baseClass is null ? "error500" : Inflector.variable(baseClass);

        return _method = method; */
    return null;
  }

  // Get error message.
  protected string errorMessage(Throwable exception, int errorCode) {
    /*         myMessage = exception.message();

        if (
            !Configure.read("debug") &&
            !(cast(HttpException)exception)
       ) {
            myMessage = errorCode < 500
                ? __d("uim", "Not Found") 
                __d("uim", "An Internal Error Has Occurred.");
        }

        return myMessage; */
    return null;
  }

  // Get template for rendering exception info.
  protected string templateName(Throwable exception, string methodName, int errorCode) {
    /*         if (cast(HttpException)exception || !Configure.read("debug")) {
            return _template = errorCode < 500 ? "error400" : "error500";
        }

        if (cast(PDOException)exception) {
            return _template = "pdo_error";
        }

        return _template = methodName; */
    return null;
  }

  // Gets the appropriate http status code for exception.
  protected int getHttpCode(Throwable exception) {
    /* return cast(HttpException)exception
            ? exception.code()
            : _exceptionHttpCodes[get_class(exception)] ?? 500; */
    return 0;
  }

  // Generate the response using the controller object.
  /* protected IResponse _outputMessage(string templateToRender) {
        /*         try {
            _controller.render(templateToRender);

            return _shutdown();
        } catch (MissingTemplateException e) {
            attributes = e.getAttributes();
            if (
                cast(MissingLayoutException)e ||
                indexOf(attributes["file"], "error500") == true
           ) {
                return _outputMessageSafe("error500");
            }

            return _outputMessage("error500");
        } catch (MissingPluginException e) {
            attributes = e.getAttributes();
            if (attributes.hasKey("plugin") && attributes["plugin"] == _controller.getPlugin()) {
                _controller.setPlugin(null);
            }

            return _outputMessageSafe("error500");
        } catch (Throwable e) {
            return _outputMessageSafe("error500");
        } * /
        return null;
    } */

  /**
     * A safer way to render error messages, replaces all helpers, with basics
     * and doesn"t call component methods.
     */
  /* protected IResponse _outputMessageSafe(string templateToRender) {
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
    } */

  /**
     * Run the shutdown events.
     * Triggers the afterFilter and afterDispatch events.
     */
  /* protected IResponse _shutdown() {
    _controller.dispatchEvent("Controller.shutdown");

    return _controller.getResponse();
  } */

  // Returns an array that can be used to describe the internal state of this object.
  Json[string] debugInfo() {
    return super.debugInfo
      .set("error", _error)
      .set("request", _request)
      .set("controller", _controller)
      .set("template", _template)
      .set("method", _method);
  }
}
