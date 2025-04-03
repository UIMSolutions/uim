/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.cell;

import uim.views;
@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
} 


abstract class DCell : UIMObject { // : IEventDispatcher {
    // TEventDispatcherTrait<IView 
    // mixin TEventDispatcher;
    // mixin TLocatorAware;
    // mixin TViewVars;

    this() {
        super();
    }

    this(Json[string] initData) {
        super(initData);
    }

    this(DStringContents newTemplate) {
        // TODO this().stringContents(newTemplate);
    }

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    // Constant for folder name containing cell templates.
    const string TEMPLATE_FOLDER = "cell";

    // The cell"s action to invoke.
    protected string _action;

    /**
     * Instance of the View created during rendering. Won"t be set until after
     * Cell.__toString()/render() is called.
     */
    protected IView _view;

    /**
     * An instance of a UIM\Http\ServerRequest object that contains information about the current request.
     * This object contains all the information about a request and several methods for reading
     * additional information about the request.
     */
    /* protected DServerRequest _request;

    // An instance of a Response object that contains information about the impending response
    protected DResponse _response; */

    // Arguments to pass to cell"s action.
    protected Json[string] _arguments = null;

    /**
     * List of valid options (constructor"s fourth arguments)
     * Override this property in subclasses to allow
     * which options you want set as properties in your Cell.
     */
    protected string[] _validCellOptions = null;

    // Caching setup.
    protected Json _cache = false;

    /* this(
        DServerRequest serverRequest,
        DResponse response,
        IEventManager eventManager = null,
        Json[string] cellOptionsToApply = null
   ) {
        if (eventManager !is null) {
            eventManager(eventManager);
        }
        _request = serverRequest;
        _response = response;

        _validCellOptions = array_merge(["action", "args"], _validCellOptions);
        /* _validCellOptions
            .filter!(var => cellOptionsToApply.hasKey(var))
            .each!(var => this.{var} = cellOptionsToApply[myvar]);
        } * /
        if (!cellOptionsToApply.isEmpty("cache")) {
           _cache = cellOptionsToApply["cache"];
        }
        initialize();
    } */

    /**
     * Render the cell.
     * Params:
     * string templateName Custom template name to render. If not provided (null), the last
     * value will be used. This value is automatically set by `CellTrait.cell()`.
     */
    string render(string templateName = null) {
        /* auto mycache = null;
        if (!_cache.isNull) {
            mycache = _cacheConfig(_action, templateName);
        } */
        /* myrender = auto () use (templateName) {
            try {
                myreflect = new DReflectionMethod(this, _action);
                myreflect.invokeArgs(this, this.args);
            } catch (ReflectionException exception) {
                throw new BadMethodCallException(
                    "Class `%s` does not have a `%s` method."
                    .format(class, _action));
            }
            auto mybuilder = viewBuilder();

            if (templateName !is null) {
                mybuilder.setTemplate(templateName);
            }
            auto myclassname = class;
            string viewsPrefix = "\View\Cell\\";
            /** @psalm-suppress PossiblyFalseOperand * /
            views = subString(myclassname, indexOf(myclassname, viewsPrefix) + viewsPrefix.length);
            views = subString(views, 0, -4);
            if (!mybuilder.getTemplatePath()) {
                mybuilder.setTemplatePath(
                    TEMPLATE_FOLDER ~ DIR_SEPARATOR ~ views.replace("\\", DIR_SEPARATOR)
               );
            }
            templateName = mybuilder.getTemplate();

            auto myview = this.createView();
            try {
                return myview.render(templateName, false);
            } catch (MissingTemplateException exception) {
                myattributes = exception.getAttributes();
                throw new DMissingTCellException(
                    views,
                    myattributes["file"],
                    myattributes["paths"],
                    null,
                    exception
               );
            }
        }; */

        /* return mycache 
            ? Cache.remember(mycache["key"], myrender, mycache["config"])
            : myrender(); */
        return null;
    }

    /**
     * Generate the cache key to use for this cell.
     *
     * If the key is undefined, the cell class DAnd action name will be used.
     */
    protected Json[string] _cacheConfig(string invokedAction, string templateName = null) {
        if (_cache.isNull) {
            return null;
        }

        templateName = templateName.ifEmpty("default");
        /* string key = ("cell_" ~ classname.underscore ~ "_" ~ invokedAction ~ "_" ~ templateName).replace("\\", "_");
        auto defaultValue = MapHelper.create!(string, Json)
            .set("config", "default")
            .set("key", key); */

        /* if (!_cache.isEmpty) {
            return defaultValue;
        }
        return _cache + defaultValue; */
        return null;
    }

    /**
     * Magic method.
     *
     * Starts the rendering process when Cell is echoed.
     *
     * *Note* This method will trigger an error when view rendering has a problem.
     * This is because UIM will not allow a __toString() method to throw an exception.
     */
    override string toString() {
        try {
            // return _render();
            return null;
        } catch (Exception exception) {
            /* trigger_error(
                "Could not render cell - %s [%s, line %d]"
                .format(exception.message(), exception.getFile(), exception.getLine()), 
                ERRORS.USER_WARNING); */

            return null;
        } /* catch (DError error) {
            /* throw new DError(
                "Could not render cell - %s [%s, line %d]"
                .format(error.message(), error.getFile(), error.line()), 
                0, error); * /
        } */
    }

    // Debug info.
    override Json[string] debugInfo(string[] showKeys = null, string[] hideKeys = null) {
        auto info = super.debugInfo(showKeys, hideKeys);
        info.set("action", Json(_action));
        info.set("args", Json(_arguments));
        // .set("request", _request)
        /* .set("response", _response)
            .set("viewBuilder", viewBuilder() */
        return info;
    }
}
