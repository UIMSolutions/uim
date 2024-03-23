module uim.events.interfaces.eventlistener;

import uim.events;

@safe:

/*
 * Objects implementing this interface should declare the `implementedEvents()` method
 * to notify the event manager what methods should be called when an event is triggered.
 */
interface IEventListener {
    /**
     * Returns a list of events this object is implementing. When the class is registered
     * in an event manager, each individual method will be associated with the respective event.
     *
     * ### Example:
     *
     * ```
     * auto implementedEvents()
     * {
     *     return [
     *         'Order.complete": `sendEmail",
     *         'Article.afterBuy": 'decrementInventory",
     *         'User.onRegister": ["callable": 'logRegistration", "priority": 20, "passParams": true]
     *     ];
     * }
     * ```
     *
     * @return IData[string] Associative array or event key names pointing to the function
     * that should be called in the object when the respective event is fired
     */
    IEvent[] implementedEvents();
}
