module uim.controllers.classes.components.registry;

import uim.controllers;

@safe:

/**
 * ComponentRegistry is a registry for loaded components
 *
 * Handles loading, constructing and binding events for component class objects.
 *
 * @template TSubject of \UIM\Controller\Controller
 * @extends \UIM\Core\ObjectRegistry<\UIM\Controller\Component>
 * @implements \UIM\Event\IEventDispatcher<TSubject>
 */
class DComponentRegistry : DObjectRegistry!DComponent { // TODO}, IEventDispatcher {
    /*
    // @use \UIM\Event\EventDispatcherTrait<TSubject>
    mixin TEventDispatcher;
*/
    // The controller that this collection is associated with.
    protected IController _controller;
    this(IController controller) {
       _controller = controller;
        // eventManager((controller.getEventManager());
    }
    
    // Get the controller associated with the collection.
    IController getController() {
        return _controller;
    }
    
    /**
     * Resolve a component classname.
     *
     * Part of the template method for {@link \UIM\Core\ObjectRegistry.load()}.
     */
    protected string _resolveclassname(string classname) {
        /** @var class-string<\UIM\Controller\Component>|null */
        // return App.classname(classname, "Controller/Component", "Component");
        return null;
    }
    
    /**
     * Throws an exception when a component is missing.
     *
     * Part of the template method for {@link \UIM\Core\ObjectRegistry.load()}
     * and {@link \UIM\Core\ObjectRegistry.unload()}
     */
    protected void _throwMissingClassError(string classname, string pluginName) {
        /* throw new DMissingComponentException([
            "class": classname ~ "Component",
            "plugin": pluginName,
        ]); */
    }
    
    /**
     * Create the component instance.
     *
     * Part of the template method for {@link \UIM\Core\ObjectRegistry.load()}
     * Enabled components will be registered with the event manager.
     * Params:
     * \UIM\Controller\Component|class-string<\UIM\Controller\Component>  classname The classname to create.
     * configData - An array of config to use for the component.
     */
    /* protected IComponent _create(string classname, string componentAlias, Json[string] configData = null) {
        if (isObject(classname)) {
            return classname;
        }
        
        auto anInstance = new  classname(this, configData);
        if (configData.getBoolean("enabled", true) {
            getEventManager().on(anInstance);
        }
        return anInstance;
    } */
}
auto ComponentRegistry() {
    return DComponentRegistry.registry;
}