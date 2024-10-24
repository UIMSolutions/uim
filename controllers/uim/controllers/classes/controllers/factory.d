/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.controllers.classes.controllers.factory;

import uim.controllers;

@safe:

/**
 * Factory method for building controllers for request.
 */
class DControllerFactory { // }: IControllerFactory, IRequestHandler {
  mixin TConfigurable;

  this() {
    initialize;
  }

  this(Json[string] initData) {
    initialize(initData);
  }

  this(IContainer container) {
    _container = container;
  }

  bool initialize(Json[string] initData = null) {
    configuration(MemoryConfiguration);
    configuration.data(initData);

    return true;
  }

  mixin(TProperty!("string", "name"));

  protected IContainer _container;

  protected IController _controller;

  /**
     * Create a controller for a given request.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest The request to build a controller for.
     */
  IController create(IServerRequest serverRequest) {
    /* assert(cast(IServerRequest) request);
        auto classname = getControllerClass(request);
        if (classname.isNull) {
            throw missingController(request);
        }
        auto myreflection = new DReflectionClass(classname);
        if (reflection.isAbstract()) {
            throw this.missingController(request);
        }
        // Get the controller from the container if defined.
        // The request is in the container by default.
        return this.container.has(classname)
            ? this.container.get(classname) 
            : reflection.newInstance(request); */
    return null;
  }

  // Invoke a controller`s action and wrapping methods
  IResponse invoke(IController controller) {
    /* _controller = controller;

         auto middlewares = controller.getMiddleware();

        if (middlewares) {
            auto middlewareQueue = new DMiddlewareQueue(middlewares, this.container);
            aut runner = new DRunner();

            return runner.run(middlewareQueue, controller.getRequest(), this);
        }
        return _handle(controller.getRequest()); */
    return null;
  }

  /**
     * Invoke the action.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest Request instance.
     */
  IResponse handle(IServerRequest serverRequest) {
    /*         assert(cast(IServerRequest) request);
        auto controller = _controller;
        controller.setRequest(request);

        auto result = controller.startupProcess();
        if (result) {
            return result;
        }
        auto action = controller.getAction();
        auto someArguments = getActionArgs(
            action,
            /* (array) * /controller.getRequest().getParam("pass").values
       );
        controller.invokeAction(action, someArguments);

        result = controller.shutdownProcess();
        if (!result.isNull) {
            return result;
        }
        return controller.getResponse(); */
    return null;
  }

  // Get the arguments for the controller action invocation.
  protected Json[string] getActionArgs(IClosure action, Json[string] passedParams) {
    auto resolved = null;
    /*         auto function = new DReflectionFunction(action);
        foreach (parameter; function.getParameters()) {
            type = parameter.getType();

            // Check for dependency injection for classes
            if (cast(ReflectionNamedType)type  && !type.isBuiltin()) {
                typeName = type.name;
                if (this.container.has(typeName)) {
                     resolved ~= this.container.get(typeName);
                    continue;
                }
                // Use passedParams as a source of typed dependencies.
                // The accepted types for passedParams was never defined and userland code relies on that.
                if (passedParams && isObject(passedParams[0]) && cast(typeName)passedParams[0]) {
                     resolved ~= passedParams.shift();
                    continue;
                }
                // Add default value if provided
                // Do not allow positional arguments for classes
                if (parameter.isDefaultValueAvailable()) {
                     resolved ~= parameter.getDefaultValue();
                    continue;
                }
/*                 auto request = _controller.getRequest();
                throw new DInvalidParameterException([
                    "template": "missing_dependency",
                    "parameter": parameter.name,
                    "type": typeName,
                    "controller": _controller.name,
                    "action": request.getParam("action"),
                    "prefix": request.getParam("prefix"),
                    "plugin": request.getParam("plugin"),
                ]);
 * /            }
            // Use any passed params as positional arguments
            if (passedParams) {
                argument = passedParams.shift;
                if (isString(argument) && cast(ReflectionNamedType)type ) {
                    typedArgument = this.coerceStringToType(argument, type);

                    if (typedArgument.isNull) {
                        throw new DInvalidParameterException(createMap!(string, Json)
                            .set("template", "failed_coercion")
                            .set("passed", argument)
                            .set("type", type.name)
                            .set("parameter", parameter.name)
                            .set("controller", _controller.name)
                            .set("action", _controller.getRequest().getParam("action"))
                            .set("prefix", _controller.getRequest().getParam("prefix"))
                            .set("plugin", _controller.getRequest().getParam("plugin")));
                    }
                    argument = typedArgument;
                }
                 resolved ~= argument;
                continue;
            }
            // Add default value if provided
            if (parameter.isDefaultValueAvailable()) {
                 resolved ~= parameter.getDefaultValue();
                continue;
            }
            // Variadic parameter can have 0 arguments
            if (parameter.isVariadic()) {
                continue;
            }
            throw new DInvalidParameterException(createMap!(string, Json)
                .set("template", "missing_parameter")
                .set("parameter", parameter.name)
                .set("controller", _controller.name)
                .set("action", _controller.getRequest().getParam("action"))
                .set("prefix", _controller.getRequest().getParam("prefix"))
                .set("plugin", _controller.getRequest().getParam("plugin")));
        }
        return array_merge(resolved, passedParams); */
    return null;
  }

  // Coerces string argument to primitive type.
  protected string[] coerceStringToType(string argumentToCoerce, /* IReflectionNamedType */ string parameterType) {
    /*         return match (parameterType.name) {
            "string": argumentToCoerce,
            "float": isNumeric(argumentToCoerce) ? (float)argumentToCoerce : null,
            "int": filter_var(argumentToCoerce, FILTER_VALIDATE_INT, FILTER_NULL_ON_FAILURE),
            "bool": argumentToCoerce == "0" ? false : (argumentToCoerce == "1" ? true : null),
            "array": argumentToCoerce is null ? [] : split(",", argumentToCoerce),
            default: Json(null),
        };
    */
    return null;
  }

  /**
     * Determine the controller class name based on current request and controller param
     * Params:
     * \UIM\Http\ServerRequest serverRequest The request to build a controller for.
     */
  string getControllerClass(IServerRequest serverRequest) {
    /* pluginPath = "";
        namespace = "Controller";
        controller = request.getParam("controller", "");
        if (request.getParam("plugin")) {
            pluginPath = request.getParam("plugin") ~ ".";
        }
        if (request.getParam("prefix")) {
            prefix = request.getParam("prefix");
            namespace ~= "/" ~ prefix;
        }
        firstChar = subString(controller, 0, 1);

        // Disallow plugin short forms, / and \\ from
        // controller names as they allow direct references to
        // be created.
        if (
            controller.contains("\\") ||
            controller.contains("/") ||
            controller.contains(".") ||
            firstChar == firstChar.lower
       ) {
            throw this.missingController(request);
        }
        /** @var class-string<\UIM\Controller\Controller>|null * /
        return App.classname(pluginPath ~ controller, namespace, "Controller"); */
    return null;
  }

  /**
     * Throws an exception when a controller is missing.
     * Params:
     * \UIM\Http\ServerRequest serverRequest The request.
     */
  //protected IMissingControllerException missingController(ServerRequest serverRequest) {
  /*         return new DMissingControllerException([
            "controller": request.getParam("controller"),
            "plugin": request.getParam("plugin"),
            "prefix": request.getParam("prefix"),
            "_ext": request.getParam("_ext"),
        ]);
 */
  //return null;    }
}
