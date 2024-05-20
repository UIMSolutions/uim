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
     * Returns a dispatched event.
     */
    IEvent dispatchEvent(string eventName, Json[string] dataToListener = null, object eventSubject = null) {
        eventSubject ??= this;

        auto event = new _eventClass(eventName, eventSubject, dataToListener);
        getEventManager().dispatch(event);

        return event;
    } 
}
