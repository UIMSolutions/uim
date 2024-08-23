module uim.events.mixins.eventdispatcher;

import uim.events;

@safe:

mixin template TEventDispatcher() {
    /**
     * Instance of the UIM\Event\EventManager this object is using
     * to dispatch inner events.
     */
    protected IEventManager _eventManager = null;

    // Default class name for new event objects.
    protected string _eventClassname; // = Event.classname;

    /**
     * Returns the UIM\Event\EventManager manager instance for this object.
     *
     * You can use this instance to register any new listeners or callbacks to the
     * object events, or create your own events and trigger them at will.
     */
    IEventManager eventManager() {
        if (_eventManager is null) {
            _eventManager = new DEventManager();
        }
        return _eventManager;
    };

    /**
     * Returns the UIM\Event\IEventManager instance for this object.
     *
     * You can use this instance to register any new listeners or callbacks to the
     * object events, or create your own events and trigger them at will.
     */
    void eventManager(IEventManager newEventManager) {
        _eventManager = newEventManager;
    }

    // Wrapper for creating and dispatching events.
    IEvent dispatchEvent(string eventName, Json[string] dataToListener = null, Object eventSubject = null) {
        eventSubject = eventSubject !is null ? eventSubject : this;

        /* auto event = new _eventClass(eventName, eventSubject, dataToListener);
        getEventManager().dispatch(event);

        return event; */
        return null;
    }
}
