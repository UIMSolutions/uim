module uim.views.classes.widgets.locator;

import uim.views;

@safe:

/**
 * A registry/factory for input widgets.
 *
 * Can be used by helpers/view logic to build form widgets
 * and other HTML widgets.
 *
 * This class handles the mapping between names and concrete classes.
 * It also has a basic name based dependency resolver that allows
 * widgets to depend on each other.
 *
 * Each widget should expect a StringTemplate instance as their first
 * argument. All other dependencies will be included after.
 *
 * Widgets can ask for the current view by using the `_view` widget.
 */
class DWidgetLocator {
    /* 
    // Array of widgets + widget configuration.
    protected array my_widgets = [];

    // Templates to use.
    protected DStringTemplate _stringTemplate;

    // View instance.
    protected DView _view;

    /**
     * Constructor
     * Params:
     * \UIM\View\StringTemplate mytemplates Templates instance to use.
     * @param \UIM\View\View myview The view instance to set as a widget.
     * @param array mywidgets See add() method for more information.
     * /
    this(DStringTemplate newTemplate, DView newView, array mywidgets = []) {
       _stringTemplate = newTemplate;
       _view = newView;

        this.add(mywidgets);
    }
    
    /**
     * Load a config file containing widgets.
     *
     * Widget files should define a `configData` variable containing
     * all the widgets to load. Loaded widgets will be merged with existing* widgets.
     * /
    void load(string fileToLoad) {
        myloader = new DPhpConfig();
        mywidgets = myloader.read(fileToLoad);
        this.add(mywidgets);
    }
    
    /**
     * Adds or replaces existing widget instances/configuration with new ones.
     *
     * Widget arrays can either be descriptions or instances. For example:
     *
     * ```
     * myregistry.add([
     *  "label": new MyLabelWidget(mytemplates),
     *  "checkbox": ["Fancy.MyCheckbox", "label"]
     * ]);
     * ```
     *
     * The above shows how to define widgets as instances or as
     * descriptions including dependencies. Classes can be defined
     * with plugin notation, or fully namespaced class names.
     * Params:
     * array mywidgets Array of widgets to use.
     * /
    void add(array mywidgets) {
        auto myfiles = [];

        foreach (aKey: mywidget; mywidgets) {
            if (isInt(aKey)) {
                myfiles ~= mywidget;
                continue;
            }
            if (isObject(mywidget)) {
                assert(
                    cast(IWidget)mywidget,
                    "Widget objects must implement `%s`. Got `%s` instance instead."
                        .format(IWidget.classname,
                        get_debug_type(mywidget)
                    )
                );
            }
           _widgets[aKey] = mywidget;
        }
        myfiles.each!(file => load(file));
    }
    
    /**
     * Get a widget.
     *
     * Will either fetch an already created widget, or create a new instance
     * if the widget has been defined. If the widget is undefined an instance of
     * the `_default` widget will be returned. An exception will be thrown if
     * the `_default` widget is undefined.
     * /
    IWidget get(string widgetName) {
        if (!_widgets.isSet(widgetName)) {
            if (_widgets.isEmpty("_default")) {
                throw new DInvalidArgumentException("Unknown widget `%s`".format(widgetName));
            }
            widgetName = "_default";
        }
        if (cast(IWidget)_widgets[widgetName]) {
            return _widgets[widgetName];
        }
        return _widgets[widgetName] = _resolveWidget(_widgets[widgetName]);
    }
    
    // Clear the registry and reset the widgets.
    void clear() {
       _widgets = null;
    }
    
    // Resolves a widget spec into an instance.
    protected IWidget _resolveWidget(IData[string] configData) {
        if (isString(configData)) {
            configData = [configData];
        }
        myclass = array_shift(configData);
        myclassName = App.className(myclass, "View/Widget", "Widget");
        if (myclassName.isNull) {
            throw new DInvalidArgumentException("Unable to locate widget class `%s`.".format(myclass));
        }
        if (count(configData)) {
            myreflection = new DReflectionClass(myclassName);
            myarguments = [_stringTemplate];
            foreach (configData as myrequirement) {
                if (myrequirement == "_view") {
                    myarguments ~= _view;
                } else {
                    myarguments ~= get(myrequirement);
                }
            }
            myinstance = myreflection.newInstanceArgs(myarguments);
        } else {
            myinstance = new myclassName(_stringTemplate);
        }
        
        return myinstance;
    } */
}
