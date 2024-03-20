module uim.events.Event;

import uim.events;

@safe:

/*
 * Objects implementing this interface can emit events.
 *
 * Objects with this interface can trigger events, and have
 * an event manager retrieved from them.
 *
 * The {@link \UIM\Event\EventDispatcherTrait} lets you easily implement
 * this interface.
 *
 * @template TSubject of object
 */
interface IEventDispatcher {
    /**
     * Wrapper for creating and dispatching events.
     *
     * Returns a dispatched event.
     * Params:
     * string aName Name of the event.
     * @param array data Any value you wish to be transported with this event to
     * it can be read by listeners.
     * @param TSubject|null subject The object that this event applies to
     * (this by default).
     * @return \UIM\Event\IEvent<TSubject>
     */
    IEvent dispatchEvent(string aName, array data = [], ?object subject = null);

    /**
     * Sets the UIM\Event\EventManager manager instance for this object.
     *
     * You can use this instance to register any new listeners or callbacks to the
     * object events, or create your own events and trigger them at will.
     * Params:
     * \UIM\Event\IEventManager eventManager the eventManager to set
     */
    auto setEventManager(IEventManager eventManager);

    /**
     * Returns the UIM\Event\EventManager manager instance for this object.
     *
     * @return \UIM\Event\IEventManager
     */
    auto getEventManager(): IEventManager;
}
