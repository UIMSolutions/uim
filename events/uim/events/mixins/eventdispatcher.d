module uim.events.mixins.eventdispatcher;

import uim.events;

@safe:

/*
 * : UIM\Event\IEventDispatcher.
 *
 * @template TSubject of object
 */
mixin template TEventDispatcher() {
    /**
     * Instance of the UIM\Event\EventManager this object is using
     * to dispatch inner events.
     *
     * @var \UIM\Event\IEventManager|null
     */
    protected IEventManager _eventManager = null;

    // Default class name for new event objects.
    protected string _eventClass = Event.class;

    /**
     * Returns the UIM\Event\EventManager manager instance for this object.
     *
     * You can use this instance to register any new listeners or callbacks to the
     * object events, or create your own events and trigger them at will.
     */
    IEventManager getEventManager() {
        return _eventManager ? _eventManager : new DEventManager();
    }

    /**
     * Returns the UIM\Event\IEventManager instance for this object.
     *
     * You can use this instance to register any new listeners or callbacks to the
     * object events, or create your own events and trigger them at will.
     */
    void setEventManager(IEventManager newEventManager) {
       _eventManager = newEventManager;
    }

    /**
     * Wrapper for creating and dispatching events.
     *
     * Returns a dispatched event.
     * Params:
     * @param Json[string] data Any value you wish to be transported with this event to
     * it can be read by listeners.
     * @param TSubject|null subject The object that this event applies to
     * (this by default).
     * @return \UIM\Event\IEvent<TSubject>
     */
    IEvent dispatchEvent(string eventName, Json[string] data = [], ?object subject = null) {
        subject ??= this;

        auto event = new _eventClass(eventName, subject, someData);
        getEventManager().dispatch(event);

        return event;
    } */
}
