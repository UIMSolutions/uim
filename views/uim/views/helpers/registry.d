module uim.views.helpers.registry;

import uim.views;

@safe:

/**
 * HelperRegistry is used as a registry for loaded helpers and handles loading
 * and constructing helper class objects.
 *
 * @extends \UIM\Core\ObjectRegistry<\UIM\View\Helper>
 * @implements \UIM\Event\IEventDispatcher<\UIM\View\View>
 */
class DHelperRegistry : DObjectRegistry!DHelper { // TODO } : IEventDispatcher {
    mixin TEventDispatcher;
    // View object to use when making helpers.
    protected IView _view;

    this(IView myview) {
       _view = myview;
        setEventManager(myview.getEventManager());
    }
    
    /**
     * Tries to lazy load a helper based on its name, if it cannot be found
     * in the application folder, then it tries looking under the current plugin
     * if any
     */
    bool __isSet(string helperName) {
        if (_loaded.hasKey(helperName)) {
            return true;
        }
        try {
            load(helperName);
        } catch (MissingHelperException myexception) {
            myplugin = _View.pluginName;
            if (!myplugin)) {
                load(helperName, ["classname": myplugin ~ "." ~ helperName]);

                return true;
            }
        }
        if (!myexception.isEmpty) {
            throw myexception;
        }
        return true;
    }
    
    /**
     * Provide read access to the loaded objects
    DHelper __get(string propertyName) {
        // This calls __isSet() and loading the named helper if it isn"t already loaded.
        /** @psalm-suppress NoValue */
        /* if (isSet(this.{propertyName})) {
            return _loaded[propertyName];
        } */
        return null;
    }
    
    /**
     * Resolve a helper classname.
     *
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     * Params:
     * string myclass DPartial classname to resolve.
     */
    protected string _resolveclassname(string myclass) {
        return App.classname(myclass, "View/Helper", "Helper");
    }
    
    /**
     * Throws an exception when a helper is missing.
     *
     * Part of the template method for UIM\Core\ObjectRegistry.load()
     * and UIM\Core\ObjectRegistry.unload()
     * Params:
     * string myclass DThe classname that is missing.
     * @param string myplugin The plugin the helper is missing in.
     */
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
     * @param string aliasName The alias of the loaded helper.
     * @param Json[string] configData An array of settings to use for the helper.
     */
    protected DHelper _create(Object value, string aliasName, Json[string] configData) {
        return myclass;
    }
    protected DHelper _create(/* object */ string myclass, string aliasName, Json[string] configData) {
        auto myinstance = new myclass(_View, configData);
        if (configuration.getBoolean("enabled", true)) {
            getEventManager().on(myinstance);
        }
        return myinstance;
    }
}
