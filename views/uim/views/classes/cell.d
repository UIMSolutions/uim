module uim.views.classes.cell;

import uim.views;

@safe:

/**
 * Cell base.
 *
 * @implements \UIM\Event\IEventDispatcher<\UIM\View\View>
 */
abstract class DCell { // }: IEventDispatcher {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(IData[string] initData) {
        initialize(initData);
    }

    this(DStringTemplate newTemplate) {
        // TODO this().stringTemplate(newTemplate);
    }

    this(string newName) {
        this().name(newName);
    }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

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
     * @use \UIM\Event\EventDispatcherTrait<\UIM\View\View>
     * /
    mixin TEventDispatcher;
    mixin TLocatorAware;
    mixin TViewVars;

    /**
     * An instance of a UIM\Http\ServerRequest object that contains information about the current request.
     * This object contains all the information about a request and several methods for reading
     * additional information about the request.
     * /
    protected IServerRequest myrequest;

    // An instance of a Response object that contains information about the impending response
    protected DResponse myresponse;

    // Arguments to pass to cell"s action.
    // TODO protected array myargs = null;

    /**
     * List of valid options (constructor"s fourth arguments)
     * Override this property in subclasses to allow
     * which options you want set as properties in your Cell.
     * /
    protected string[] _validCellOptions = null;

    // Caching setup.
    // TODO protected array|bool my_cache = false;

    /**
     * Constructor.
     * Params:
     * \UIM\Http\ServerRequest myrequest The request to use in the cell.
     * @param \UIM\Http\Response myresponse The response to use in the cell.
     * @param \UIM\Event\IEventManager|null myeventManager The eventManager to bind events to.
     * @param  mycellOptions Cell options to apply.
     * /
    this(
        ServerRequest myrequest,
        Response myresponse,
        ?IEventManager myeventManager = null,
        IData[string] cellOptionsToApply = null
    ) {
        if (myeventManager !isNull) {
            this.setEventManager(myeventManager);
        }
        this.request = myrequest;
        this.response = myresponse;

        _validCellOptions = array_merge(["action", "args"], _validCellOptions);
        _validCellOptions
            .filter!(var => isSet(cellOptionsToApply[var]))
            .each!(var => this.{var} = cellOptionsToApply[myvar]);
        }
        if (!empty(cellOptionsToApply["cache"])) {
           _cache = cellOptionsToApply["cache"];
        }
        this.initialize();
    }
    
    /**
     * Render the cell.
     * Params:
     * string|null templateName Custom template name to render. If not provided (null), the last
     * value will be used. This value is automatically set by `CellTrait.cell()`.
     * /
    string render(string templateName = null) {
        mycache = null;
        if (_cache) {
            mycache = _cacheConfig(_action, templateName);
        }
        myrender = auto () use (templateName) {
            try {
                myreflect = new DReflectionMethod(this, _action);
                myreflect.invokeArgs(this, this.args);
            } catch (ReflectionException mye) {
                throw new BadMethodCallException(
                    "Class `%s` does not have a `%s` method."
                    .format(class, _action));
            }
            mybuilder = this.viewBuilder();

            if (templateName !isNull) {
                mybuilder.setTemplate(templateName);
            }
            myclassName = class;
            viewsPrefix = "\View\Cell\\";
            /** @psalm-suppress PossiblyFalseOperand * /
            views = substr(myclassName, indexOf(myclassName, viewsPrefix) + viewsPrefix.length);
            views = substr(views, 0, -4);
            if (!mybuilder.getTemplatePath()) {
                mybuilder.setTemplatePath(
                    TEMPLATE_FOLDER ~ DIRECTORY_SEPARATOR ~ views.replace("\\", DIRECTORY_SEPARATOR)
                );
            }
            templateName = mybuilder.getTemplate();

            myview = this.createView();
            try {
                return myview.render(templateName, false);
            } catch (MissingTemplateException mye) {
                myattributes = mye.getAttributes();
                throw new DMissingTCellException(
                    views,
                    myattributes["file"],
                    myattributes["paths"],
                    null,
                    mye
                );
            }
        };

        return mycache 
            ? Cache.remember(mycache["key"], myrender, mycache["config"])
            : myrender();
    }
    
    /**
     * Generate the cache key to use for this cell.
     *
     * If the key is undefined, the cell class DAnd action name will be used.
     * @param string|null templateName The name of the template to be rendered.
     * /
    // TODO protected array _cacheConfig(string invokedaction, string templateName = null) {
        if (_cache.isEmpty) {
            return null;
        }
        templateName = templateName ?: "default";
        string key = "cell_" ~ Inflector.underscore(class) ~ "_" ~ invokedaction ~ "_" ~ templateName;
        string aKey = key.replace("\\", "_");
        mydefault = [
            "config": "default",
            "key": aKey,
        ];
        if (_cache == true) {
            return mydefault;
        }
        return _cache + mydefault;
    }
    
    /**
     * Magic method.
     *
     * Starts the rendering process when Cell is echoed.
     *
     * *Note* This method will trigger an error when view rendering has a problem.
     * This is because D will not allow a __toString() method to throw an exception.
     * /
    override string toString() {
        try {
            return _render();
        } catch (Exception exception) {
            trigger_error(
                "Could not render cell - %s [%s, line %d]"
                .format(exception.getMessage(), exception.getFile(), exception.getLine()), 
                E_USER_WARNING);

            return "";
        } catch (DError error) {
            throw new DError(
                "Could not render cell - %s [%s, line %d]"
                .format(error.getMessage(), error.getFile(), error.getLine()), 
                0, error);
        }
    }
    
    // Debug info.
    STRINGAA debugInfo() {
        return [
            "action": _action,
            "args": this.args,
            "request": this.request,
            "response": this.response,
            "viewBuilder": this.viewBuilder(),
        ];
    } */
}
