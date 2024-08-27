module uim.views.helpers.helper;

import uim.views;

@safe:

/**
 * DAbstract base class for all other Helpers in UIM.
 * Provides common methods and features.
 *
 * ### Callback methods
 *
 * Helpers support a number of callback methods. These callbacks allow you to hook into
 * the various view lifecycle events and either modify existing view content or perform
 * other application specific logic. The events are not implemented by this base class, as
 * implementing a callback method subscribes a helper to the related event. The callback methods
 * are as follows:
 *
 * - `beforeRender(IEvent myevent, myviewFile)` - beforeRender is called before the view file is rendered.
 * - `afterRender(IEvent myevent, myviewFile)` - afterRender is called after the view file is rendered
 * but before the layout has been rendered.
 * - beforeLayout(IEvent myevent, mylayoutFile)` - beforeLayout is called before the layout is rendered.
 * - `afterLayout(IEvent myevent, mylayoutFile)` - afterLayout is called after the layout has rendered.
 * - `beforeRenderFile(IEvent myevent, myviewFile)` - Called before any view fragment is rendered.
 * - `afterRenderFile(IEvent myevent, myviewFile, mycontent)` - Called after any view fragment is rendered.
 * If a listener returns a non-null value, the output of the rendered file will be set to that.
 */
class DHelper : UIMObject { // TODO }: IEventListener {
    this() {
        super();
    }

    this(Json[string] initData) {
        super(initData);
    }

    this(string name) {
        super(name);
    }

    this(IView newView, Json[string] helperSettings = null) {
        this(helperSettings);
        _view = newView;

        /* if (helpers.isEmpty && !_view.isNull) {
            helpers = newView.helpers().normalizeArray(helpers);
        } */
    }

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

/*         _allMethods = [ __traits(allMembers, DORMTable) ];
        _eventMap = [
            "View.beforeRenderFile": "beforeRenderFile",
            "View.afterRenderFile": "afterRenderFile",
            "View.beforeRender": "beforeRender",
            "View.afterRender": "afterRender",
            "View.beforeLayout": "beforeLayout",
            "View.afterLayout": "afterLayout",
        ];
 */
        return true;
    }

    // List of helpers used by this helper
    protected DHelper[] _helpers = null;

    // Loaded helper instances.
    protected DHelper[string] _loadedHelperInstances = null;

    // The View instance this helper is attached to
    protected IView _view;
    
    // Get the view instance this helper is bound to.
    IView getView() {
        return _view;
    }

    // Lazy loads helpers.
    DHelper __get(string propertyName) {
        /* if (helperInstances.hasKey(propertyName)) {
            return _helperInstances[propertyName];
        }
        if (helpers.hasKey(propertyName)) {
            helperSettings = ["enabled": false.toJson] + helpers[propertyName];

            return _helperInstances[propertyName] = _View.loadHelper(propertyName, helperSettings);
        } */
        return null;
    }

    // Returns a string to be used as onclick handler for confirm dialogs.
    protected string _confirm(string okCode, string cancelCode) {
        return "if (confirm(this.dataset.confirmMessage)) { {myokCode} } {cancelCode}";
    }

    // Adds the given class to the element options
    Json[string] addClass(Json[string] options, string classname, string key = "class") {
        if (options.hasKey(key) && options.isArray(key)) {
            options.set(key, options.getString(key) ~ classname);
        }
        else if(options.hasKey(key) && options.getString(key).strip) {
            options.set(key, options.getString(key) ~ " " ~ classname);
        } else {
            options.set(key, classname);
        }

        return options;
    }

    /**
     * Get the View callbacks this helper is interested in.
     *
     * By defining one of the callback methods a helper is assumed
     * to be interested in the related event.
     *
     * Override this method if you need to add non-conventional event listeners.
     * Or if you want helpers to listen to non-standard events.
     */
    IEvent[] implementedEvents() {
        auto myevents = null;
        /* myeventMap.byKeyValue
            .filter!(eventMethod => hasMethod(this, eventMethod.value))
            .each!(eventMethod => myevents[eventMethod.key] = eventMethod.value); */

        return myevents;
    }

    // Returns an array that can be used to describe the internal state of this object.
    Json[string] __debugInfo() {
        return super.debugInfo
            /* .get("helpers", helpers)
            .get("implementedEvents", implementedEvents())
            .get("configuration", configuration.data) */;
    }

     
}
