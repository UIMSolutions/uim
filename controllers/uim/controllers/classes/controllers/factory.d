module uim.controllers.classes.controllers.factory;

import uim.controllers;

@safe:

/**
 * Factory method for building controllers for request.
 *
 * @implements \UIM\Http\IControllerFactory<\UIM\Controller\Controller>
 */
class DControllerFactory { // }: IControllerFactory, IRequestHandler {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    /* 
    // \UIM\Core\IContainer
    protected IContainer container;

    protected IController controller;

    this(IContainer container) {
        this.container = container;
    }
    
    /**
     * Create a controller for a given request.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest The request to build a controller for.
     * /
    Controller create(IServerRequest serverRequest) {
        assert(cast(DServerRequest) request);
        auto className = this.getControllerClass(request);
        if (className.isNull) {
            throw this.missingController(request);
        }
        auto myreflection = new DReflectionClass(className);
        if (reflection.isAbstract()) {
            throw this.missingController(request);
        }
        // Get the controller from the container if defined.
        // The request is in the container by default.
        return this.container.has(className)
            ? this.container.get(className) 
            : reflection.newInstance(request);
    }
    
    /**
     * Invoke a controller`s action and wrapping methods.
     * Params:
     * \UIM\Controller\Controller controller The controller to invoke.
     * /
    IResponse invoke(Json controller) {
        this.controller = controller;

         middlewares = controller.getMiddleware();

        if (middlewares) {
             middlewareQueue = new DMiddlewareQueue(middlewares, this.container);
             runner = new DRunner();

            return  runner.run(middlewareQueue, controller.getRequest(), this);
        }
        return _handle(controller.getRequest());
    }
    
    /**
     * Invoke the action.
     * Params:
     * \Psr\Http\Message\IServerRequest serverRequest Request instance.
     * /
    IResponse handle(IServerRequest serverRequest) {
        assert(cast(DServerRequest) request);
        controller = this.controller;
        controller.setRequest(request);

        result = controller.startupProcess();
        if (result) {
            return result;
        }
        action = controller.getAction();
        someArguments = this.getActionArgs(
            action,
            (array)controller.getRequest().getParam("pass").values
        );
        controller.invokeAction(action, someArguments);

        result = controller.shutdownProcess();
        if (result !isNull) {
            return result;
        }
        return controller.getResponse();
    }
    
    /**
     * Get the arguments for the controller action invocation.
     * Params:
     * \Closure action Controller action.
     * @param Json[string] passedParams Params passed by the router.
     * /
    // TODO protected Json[string] getActionArgs(Closure action, Json[string] passedParams) {
         resolved = null;
        function = new DReflectionFunction(action);
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
                     resolved ~= array_shift(passedParams);
                    continue;
                }
                // Add default value if provided
                // Do not allow positional arguments for classes
                if (parameter.isDefaultValueAvailable()) {
                     resolved ~= parameter.getDefaultValue();
                    continue;
                }
                throw new DInvalidParameterException([
                    "template": "missing_dependency",
                    "parameter": parameter.name,
                    "type": typeName,
                    "controller": this.controller.name,
                    "action": this.controller.getRequest().getParam("action"),
                    "prefix": this.controller.getRequest().getParam("prefix"),
                    "plugin": this.controller.getRequest().getParam("plugin"),
                ]);
            }
            // Use any passed params as positional arguments
            if (passedParams) {
                argument = array_shift(passedParams);
                if (isString(argument) && cast(ReflectionNamedType)type  ) {
                    typedArgument = this.coerceStringToType(argument, type);

                    if (typedArgument.isNull) {
                        throw new DInvalidParameterException([
                            "template": 'failed_coercion",
                            "passed": argument,
                            "type": type.name,
                            "parameter": parameter.name,
                            "controller": this.controller.name,
                            "action": this.controller.getRequest().getParam("action"),
                            "prefix": this.controller.getRequest().getParam("prefix"),
                            "plugin": this.controller.getRequest().getParam("plugin"),
                        ]);
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
            throw new DInvalidParameterException([
                "template": "missing_parameter",
                "parameter": parameter.name,
                "controller": this.controller.name,
                "action": this.controller.getRequest().getParam("action"),
                "prefix": this.controller.getRequest().getParam("prefix"),
                "plugin": this.controller.getRequest().getParam("plugin"),
            ]);
        }
        return array_merge(resolved, passedParams);
    }
    
    /**
     * Coerces string argument to primitive type.
     * Params:
     * string aargument Argument to coerce
     * @param \ReflectionNamedType type Parameter type
     * /
    protected string[]|float|int|bool|null coerceStringToType(string argumentToCoerce, ReflectionNamedType type) {
        return match (type.name) {
            "string": argumentToCoerce,
            "float": isNumeric(argumentToCoerce) ? (float)argumentToCoerce : null,
            "int": filter_var(argumentToCoerce, FILTER_VALIDATE_INT, FILTER_NULL_ON_FAILURE),
            "bool": argumentToCoerce == "0" ? false : (argumentToCoerce == "1" ? true : null),
            "array": argumentToCoerce == "" ? [] : split(",", argumentToCoerce),
            default: null,
        };
    }
    
    /**
     * Determine the controller class name based on current request and controller param
     * Params:
     * \UIM\Http\ServerRequest serverRequest The request to build a controller for.
     * /
    string getControllerClass(DServerRequest serverRequest) {
        pluginPath = "";
        namespace = "Controller";
        controller = request.getParam("controller", "");
        if (request.getParam("plugin")) {
            pluginPath = request.getParam("plugin") ~ ".";
        }
        if (request.getParam("prefix")) {
            prefix = request.getParam("prefix");
            namespace ~= "/" ~ prefix;
        }
        firstChar = substr(controller, 0, 1);

        // Disallow plugin short forms, / and \\ from
        // controller names as they allow direct references to
        // be created.
        if (
            controller.has("\\") ||
            controller.has("/") ||
            controller.has(".") ||
            firstChar == firstChar.toLower
        ) {
            throw this.missingController(request);
        }
        /** @var class-string<\UIM\Controller\Controller>|null * /
        return App.className(pluginPath ~ controller, namespace, "Controller");
    }
    
    /**
     * Throws an exception when a controller is missing.
     * Params:
     * \UIM\Http\ServerRequest serverRequest The request.
     * /
    protected DMissingControllerException missingController(ServerRequest serverRequest) {
        return new DMissingControllerException([
            "controller":  request.getParam("controller"),
            "plugin":  request.getParam("plugin"),
            "prefix":  request.getParam("prefix"),
            "_ext":  request.getParam("_ext"),
        ]);
    } */
}
