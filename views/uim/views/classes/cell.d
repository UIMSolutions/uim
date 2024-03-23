module uim.views.classes.cell;

import uim.views;

@safe:

/**
 * Cell base.
 *
 * @implements \UIM\Event\IEventDispatcher<\UIM\View\View>
 */
abstract class Cell { // }: IEventDispatcher, Stringable {
    /**
     * @use \UIM\Event\EventDispatcherTrait<\UIM\View\View>
     * /
    use EventDispatcherTrait;
    use LocatorAwareTrait;
    use ViewVarsTrait;

    // Constant for folder name containing cell templates.
    const string TEMPLATE_FOLDER = "cell";

    /**
     * Instance of the View created during rendering. Won"t be set until after
     * Cell.__toString()/render() is called.
     * /
    protected View _view;

    /**
     * An instance of a UIM\Http\ServerRequest object that contains information about the current request.
     * This object contains all the information about a request and several methods for reading
     * additional information about the request.
     * /
    protected ServerRequest myrequest;

    // An instance of a Response object that contains information about the impending response
    protected Response myresponse;

    // The cell"s action to invoke.
    protected string myaction;

    // Arguments to pass to cell"s action.
    protected array myargs = [];

    /**
     * List of valid options (constructor"s fourth arguments)
     * Override this property in subclasses to allow
     * which options you want set as properties in your Cell.
     * /
    protected string[] my_validCellOptions = [];

    // Caching setup.
    protected array|bool my_cache = false;

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
     * Initialization hook method.
     *
     * Implement this method to avoid having to overwrite
     * the constructor and calling super().
     * /
    bool initialize(IData[string] initData = null) {
    }
    
    /**
     * Render the cell.
     * Params:
     * string|null mytemplate Custom template name to render. If not provided (null), the last
     * value will be used. This value is automatically set by `CellTrait.cell()`.
     * /
    string render(string mytemplate = null) {
        mycache = [];
        if (_cache) {
            mycache = _cacheConfig(this.action, mytemplate);
        }
        myrender = auto () use (mytemplate) {
            try {
                myreflect = new ReflectionMethod(this, this.action);
                myreflect.invokeArgs(this, this.args);
            } catch (ReflectionException mye) {
                throw new BadMethodCallException(
                    "Class `%s` does not have a `%s` method."
                    .format(class,
                    this.action
                ));
            }
            mybuilder = this.viewBuilder();

            if (mytemplate !isNull) {
                mybuilder.setTemplate(mytemplate);
            }
            myclassName = class;
            viewsPrefix = "\View\Cell\\";
            /** @psalm-suppress PossiblyFalseOperand * /
            views = substr(myclassName, strpos(myclassName, viewsPrefix) + viewsPrefix.length);
            views = substr(views, 0, -4);
            if (!mybuilder.getTemplatePath()) {
                mybuilder.setTemplatePath(
                    TEMPLATE_FOLDER ~ DIRECTORY_SEPARATOR ~ views.replace("\\", DIRECTORY_SEPARATOR)
                );
            }
            mytemplate = mybuilder.getTemplate();

            myview = this.createView();
            try {
                return myview.render(mytemplate, false);
            } catch (MissingTemplateException mye) {
                myattributes = mye.getAttributes();
                throw new MissingCellTemplateException(
                    views,
                    myattributes["file"],
                    myattributes["paths"],
                    null,
                    mye
                );
            }
        };

        if (mycache) {
            return Cache.remember(mycache["key"], myrender, mycache["config"]);
        }
        return myrender();
    }
    
    /**
     * Generate the cache key to use for this cell.
     *
     * If the key is undefined, the cell class and action name will be used.
     * Params:
     * string myaction The action invoked.
     * @param string|null mytemplate The name of the template to be rendered.
     * /
    protected array _cacheConfig(string myaction, string mytemplate = null) {
        if (_cache.isEmpty) {
            return null;
        }
        mytemplate = mytemplate ?: "default";
        string key = "cell_" ~ Inflector.underscore(class) ~ "_" ~ myaction ~ "_" ~ mytemplate;
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
     * This is because PHP will not allow a __toString() method to throw an exception.
     * /
    override string toString() {
        try {
            return this.render();
        } catch (Exception mye) {
            trigger_error(
                "Could not render cell - %s [%s, line %d]".format(
                mye.getMessage(),
                mye.getFile(),
                mye.getLine()
            ), E_USER_WARNING);

            return "";
        /** @phpstan-ignore-next-line * /
        } catch (Error mye) {
            throw new Error(
                "Could not render cell - %s [%s, line %d]".format(
                mye.getMessage(),
                mye.getFile(),
                mye.getLine()
            ), 0, mye);
        }
    }
    
    /**
     * Debug info.
     * /
    IData[string] debugInfo() {
        return [
            "action": this.action,
            "args": this.args,
            "request": this.request,
            "response": this.response,
            "viewBuilder": this.viewBuilder(),
        ];
    } */
}
