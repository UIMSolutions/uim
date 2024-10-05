/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.controllers.classes.components.component;

import uim.controllers;

@safe:

/**
 * Base class for an individual Component. Components provide reusable bits of
 * controller logic that can be composed into a controller. Components also
 * provide request life-cycle callbacks for injecting logic at specific points.
 *
 * ### Initialize hook
 *
 * Like Controller and Table, this class has an initialize() hook that you can use
 * to add custom 'constructor' logic. It is important to remember that each request
 * (and sub-request) will only make one instance of any given component.
 *
 * ### Life cycle callbacks
 *
 * Components can provide several callbacks that are fired at various stages of the request
 * cycle. The available callbacks are:
 *
 * - `beforeFilter(IEvent event)`
 * Called before Controller.beforeFilter() method by default.
 * - `startup(IEvent event)`
 * Called after Controller.beforeFilter() method, and before the
 * controller action is called.
 * - `beforeRender(IEvent event)`
 * Called before Controller.beforeRender(), and before the view class is loaded.
 * - `afterFilter(IEvent event)`
 * Called after the action is complete and the view has been rendered but
 * before Controller.afterFilter().
 * - `beforeRedirect(IEvent event url, Response response)`
 * Called before a redirect is done. Allows you to change the URL that will
 * be redirected to by returning a Response instance with new URL set using
 * Response.location(). Redirection can be prevented by stopping the event
 * propagation.
 *
 * While the controller is not an explicit argument for the callback methods it
 * is the subject of each event and can be fetched using IEvent.getSubject().
 */
class DComponent : UIMObject, IEventListener {
    mixin(ComponentThis!());
    mixin TLog;

    // Hook method
    override bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        // _methodNames = [__traits(allMembers, DComponent)];

        _eventMap = [
            "Controller.initialize": "beforeFilter",
            "Controller.startup": "startup",
            "Controller.beforeRender": "beforeRender",
            "Controller.beforeRedirect": "beforeRedirect",
            "Controller.shutdown": "afterFilter",
        ];

        return true;
    }

    // Component registry class used to lazy load components.
    protected DComponentRegistry _registry;

    // Other Components this component uses.
    protected Json[string] components = null;

    // Loaded component instances.
    protected IComponent[string] componentInstances = null;

    /**
     
     * Params:
     * \UIM\Controller\ComponentRegistry  registry A component registry
     * this component can use to lazy load its components.
     * configData = Array of configuration settings.
     */
    this(DComponentRegistry registry, Json[string] initData = null) {
        /* _registry = registry;

        configuration.set(initData);

        if (this.components) {
            _components = registry.normalizeArray(_components);
        }
        this.initialize(initData); */
    }

    // Get the controller this component is bound to.
    IController getController() {
        return _registry.getController();
    }

    /**
     * Magic method for lazy loading components.
     * Returns A Component object or null.
     * 
     * Params:
     * componentName = Name of component to get.
     */
    IComponent __get(string componentName) {
        /* if (_componentInstances.hasKey(componentName)) {
            return _componentInstances[componentName];
        }
        if (_components.hasKey(componentName)) {
            auto data = _components.getString(componentName) ~ [
                "enabled": false.toJson
            ];

            return _componentInstances.set(componentName,
                _registry.load(componentName, data));
        } */
        return null;
    }

    /**
     * Get the Controller callbacks this Component is interested in.
     *
     * Uses Conventions to map controller events to standard component
     * callback method names. By defining one of the callback methods a
     * component is assumed to be interested in the related event.
     *
     * Override this method if you need to add non-conventional event listeners.
     * Or if you want components to listen to non-standard events.
     */
    protected STRINGAA _eventMap;
    IEvent[] implementedEvents() {
        Json[string] myEvents;
        /* eventMap.byKeyValue
            .filter!(kv => hasMethod(this, kv.value))
            .each!(eventMethod => myEvents[eventMethod.key] = eventMethod.value);
 */
        return null; // myEvents;
    }

    // Returns an array that can be used to describe the internal state of this object.
    // TODO 

    override Json[string] debugInfo() {
        return super.debugInfo();
        // .set("components", _components)
        /*             .set("implementedEvents", implementedEvents())
            .set("_config", _configuration.data); */
    }
}

unittest {
    // assert(DCheckHttpCacheComponent);
}
