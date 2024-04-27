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
 *  Called before Controller.beforeFilter() method by default.
 * - `startup(IEvent event)`
 *  Called after Controller.beforeFilter() method, and before the
 *  controller action is called.
 * - `beforeRender(IEvent event)`
 *  Called before Controller.beforeRender(), and before the view class is loaded.
 * - `afterFilter(IEvent event)`
 *  Called after the action is complete and the view has been rendered but
 *  before Controller.afterFilter().
 * - `beforeRedirect(IEvent event url, Response response)`
 *  Called before a redirect is done. Allows you to change the URL that will
 *  be redirected to by returning a Response instance with new URL set using
 *  Response.location(). Redirection can be prevented by stopping the event
 *  propagation.
 *
 * While the controller is not an explicit argument for the callback methods it
 * is the subject of each event and can be fetched using IEvent.getSubject().
 *
 * @link https://book.UIM.org/5/en/controllers/components.html
 * @see \UIM\Controller\Controller.components
 */
class DComponent { // TODO }: IEventListener {
    mixin TConfigurable;
    mixin TLog;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    // Component registry class used to lazy load components.
    protected DComponentRegistry _registry;

    // Other Components this component uses.
    // TODO // TODO protected array components = null;

    // Loaded component instances.
    protected IComponent[string] componentInstances = null;

    /**
     * Constructor
     * Params:
     * \UIM\Controller\ComponentRegistry  registry A component registry
     * this component can use to lazy load its components.
     * configData = Array of configuration settings.
     * /
    this(DComponentRegistry registry, Json[string] configData = null) {
        _registry = registry;

        configuration.update(configData);

        if (this.components) {
            this.components = registry.normalizeArray(this.components);
        }
        this.initialize(configData);
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
     * /
    IComponent __get(string componentName) {
        if (isSet(this.componentInstances[componentName])) {
            return _componentInstances[componentName];
        }
        if (isSet(this.components[componentName])) {
            configData = this.components[componentName] ~ [
                "enabled": BooleanData(false)
            ];

            return _componentInstances[componentName] = _registry.load(
                componentName,
                configData
            );
        }
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
     * /
    IEvent[] implementedEvents() {
        auto eventMap = [
            "Controller.initialize": "beforeFilter",
            "Controller.startup": "startup",
            "Controller.beforeRender": "beforeRender",
            "Controller.beforeRedirect": "beforeRedirect",
            "Controller.shutdown": "afterFilter",
        ];

        Json[string] myEvents;
        eventMap.byKeyValue
            .filter!(kv => method_exists(this, kv.value))
            .each!(eventMethod => myEvents[eventMethod.key] = eventMethod.value);

        return myEvents;
    }

    // Returns an array that can be used to describe the internal state of this object.
    // TODO 
    /*
    STRINGAA debugInfo() {
        return [
            "components": this.components, 
            "implementedEvents": this.implementedEvents(),
            "_config": this.configuration.data,
        ];
    } */
}
