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
     */
    protected IEventManager _eventManager = null;

    // Default class name for new event objects.
    protected string _eventClass = Event.classname;

    /**
     * Returns the UIM\Event\EventManager manager instance for this object.
     *
     * You can use this instance to register any new listeners or callbacks to the
     * object events, or create your own events and trigger them at will.
     */
    IEventManager eventManager() {
        return _eventManager ? _eventManager : {
            _eventManager = new DEventManager();
            return _eventManager; };
    }

    /**
     * Returns the UIM\Event\IEventManager instance for this object.
     *
     * You can use this instance to register any new listeners or callbacks to the
     * object events, or create your own events and trigger them at will.
     */
    void eventManager(IEventManager newEventManager) {
       _eventManager = newEventManager;
    }

    /**
     * Wrapper for creating and dispatching events.
     * Returns a dispatched event.
     */
    IEvent dispatchEvent(string eventName, Json[string] dataToListener = null, object eventSubject = null) {
//TODO
/*        eventSubject ??= this;

        auto event = new _eventClass(eventName, eventSubject, dataToListener);
        getEventManager().dispatch(event);
 */
//TODO         return event;
return null; 
    } 
}
