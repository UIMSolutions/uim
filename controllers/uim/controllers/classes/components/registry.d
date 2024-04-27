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

    // The controller that this collection is associated with.
    protected IController _controller;

    /**
     * Constructor.
     * Params:
     * \UIM\Controller\Controller controller Controller instance.
     * /
    this(IController controller) {
       _Controller = controller;
        this.setEventManager(controller.getEventManager());
    }
    
    // Get the controller associated with the collection.
    IController getController() {
        return _Controller;
    }
    
    /**
     * Resolve a component classname.
     *
     * Part of the template method for {@link \UIM\Core\ObjectRegistry.load()}.
     * /
    protected string _resolveClassName(string className) {
        /** @var class-string<\UIM\Controller\Component>|null * /
        return App.className(className, "Controller/Component", "Component");
    }
    
    /**
     * Throws an exception when a component is missing.
     *
     * Part of the template method for {@link \UIM\Core\ObjectRegistry.load()}
     * and {@link \UIM\Core\ObjectRegistry.unload()}
     * Params:
     * @throws \UIM\Controller\Exception\MissingComponentException
     * /
    protected void _throwMissingClassError(string className, string pluginName) {
        throw new DMissingComponentException([
            "class":  className ~ "Component",
            "plugin": pluginName,
        ]);
    }
    
    /**
     * Create the component instance.
     *
     * Part of the template method for {@link \UIM\Core\ObjectRegistry.load()}
     * Enabled components will be registered with the event manager.
     * Params:
     * \UIM\Controller\Component|class-string<\UIM\Controller\Component>  className The classname to create.
     * @param string aalias The alias of the component.
     * configData - An array of config to use for the component.
     * /
    protected IComponent _create(object|string className, string aalias, Json[string] configData = null) {
        if (isObject(className)) {
            return className;
        }
         anInstance = new  className(this, configData);
        if (configData["enabled"] ?? true) {
            this.getEventManager().on(anInstance);
        }
        return anInstance;
    } */
}
