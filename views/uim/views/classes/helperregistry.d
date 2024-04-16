module uim.views.classes.helperregistry;

import uim.views;

@safe:

/**
 * HelperRegistry is used as a registry for loaded helpers and handles loading
 * and constructing helper class objects.
 *
 * @extends \UIM\Core\ObjectRegistry<\UIM\View\Helper>
 * @implements \UIM\Event\IEventDispatcher<\UIM\View\View>
 */
class DHelperRegistry { // }: ObjectRegistry : IEventDispatcher {
    // View object to use when making helpers.
    protected IView _view;

    /**
     * @use \UIM\Event\EventDispatcherTrait<\UIM\View\View>
     * /
    mixin TEventDispatcher;

    /**
     * Constructor
     * Params:
     * \UIM\View\View myview View object.
     * /
    this(IView myview) {
       _view = myview;
        this.setEventManager(myview.getEventManager());
    }
    
    /**
     * Tries to lazy load a helper based on its name, if it cannot be found
     * in the application folder, then it tries looking under the current plugin
     * if any
     * Params:
     * string myhelper The helper name to be loaded
     * /
    bool __isSet(string myhelper) {
        if (isSet(_loaded[myhelper])) {
            return true;
        }
        try {
            this.load(myhelper);
        } catch (MissingHelperException myexception) {
            myplugin = _View.pluginName;
            if (!empty(myplugin)) {
                this.load(myhelper, ["className": myplugin ~ "." ~ myhelper]);

                return true;
            }
        }
        if (!empty(myexception)) {
            throw myexception;
        }
        return true;
    }
    
    /**
     * Provide read access to the loaded objects
     * Params:
     * string viewNameName of property to read
     * /
    Helper __get(string viewName) {
        // This calls __isSet() and loading the named helper if it isn"t already loaded.
        /** @psalm-suppress NoValue * /
        if (isSet(this.{viewName})) {
            return _loaded[viewName];
        }
        return null;
    }
    
    /**
     * Resolve a helper classname.
     *
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     * Params:
     * string myclass DPartial classname to resolve.
     * /
    protected string _resolveClassName(string myclass) {
        return App.className(myclass, "View/Helper", "Helper");
    }
    
    /**
     * Throws an exception when a helper is missing.
     *
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     * and UIM\Core\ObjectRegistry.unload()
     * Params:
     * string myclass DThe classname that is missing.
     * @param string|null myplugin The plugin the helper is missing in.
     * /
    protected void _throwMissingClassError(string myclass, string myplugin) {
        throw new DMissingHelperException([
            "class": myclass ~ "Helper",
            "plugin": myplugin,
        ]);
    }
    
    /**
     * Create the helper instance.
     *
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     * Enabled helpers will be registered with the event manager.
     * Params:
     * \UIM\View\Helper|class-string<\UIM\View\Helper> myclass DThe class to create.
     * @param string myalias The alias of the loaded helper.
     * @param IData[string] configData An array of settings to use for the helper.
     * /
    protected DHelper _create(object|string myclass, string myalias, IData[string] configData) {
        if (isObject(myclass)) {
            return myclass;
        }
        myinstance = new myclass(_View, configData);

        if (configuration.get("enabled"] ?? true) {
            this.getEventManager().on(myinstance);
        }
        return myinstance;
    } */
}
