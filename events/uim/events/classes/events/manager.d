module uim.events.classes.events.manager;

import uim.events;

@safe:

/**
 * The event manager is responsible for keeping track of event listeners, passing the correct
 * data to them, and firing them in the correct order, when associated events are triggered. You
 * can create multiple instances of this object to manage local events or keep a single instance
 * and pass it around to manage all events in your app.
 */
class DEventManager : IEventManager {
    // The default priority queue value for new, attached listeners
    static long _defaultPriority = 10;

    // The event list object.
    protected DEventList _eventList = null;

    // Internal flag to distinguish a common manager from the singleton
    protected bool _isGlobal = false;

    // Enables automatic adding of events to the event list object if it is present.
    protected bool _canAddEvents = false;

    // The globally available instance, used for dispatching events attached from any scope
    protected static DEventManager _generalManager = null;

    // List of listener callbacks associated to
    protected Json[string] _listeners = null;

    /**
     * Returns the globally available instance of a UIM\Event\EventManager
     * this is used for dispatching events attached from outside the scope
     * other managers were created. Usually for creating hook systems or inter-class
     * communication
     *
     * If called with the first parameter, it will be set as the globally available instance
     */
    static DEventManager instance(DEventManager manager = null) {
        if (_generalManager is null) {
            _generalManager = new DEventManager();
        }
        _generalManager._isGlobal = true;

        return _generalManager;
    }

    IEventManager on(IEventListener eventKey, Json[string] options = null) {
        _attachSubscriber(eventKey);
        return this;
    }

    IEventManager on(string eventKey, /* callable | */ Json[string] options = null, /* callable callable = null */
    ) {
        // TODO
        /* if (!aCallable && !isCallable(options)) {
            throw new DInvalidArgumentException(
                "second argument of `EventManager.on()` must be a callable if `aCallable`.isNull."
           );
        }
        if (!aCallable) {
            /** @var callable options */
        /*        _listeners[eventKey][defaultPriority).concat( [
            "callable": options(...),
        ];

        return;
        }*/

        long priority = options.getLong("priority", _defaultPriority);
        // TODO  _listeners[eventKey][priority].concat("callable": aCallable(...)];  
        return this;  
    }

    /**
     * Auxiliary auto to attach all implemented callbacks of a UIM\Event\IEventListener class instance
     * as individual methods on this manager
     */
    protected IEventManager _attachSubscriber(IEventListener subscriber) {
        foreach (eventKey, handlers; subscriber.implementedEvents()) {
/*         foreach (this.normalizeHandlers(subscriber, handlers) as handler) {
            this.on(eventKey, handler["settings"], handler["callable"]);
        } */
        }
        return this; 
    }

    IEventManager off(IEventListener listener) {
        _detachSubscriber(listener);
        // TODO _detachSubscriber(aCallable, eventKey);
        return this; 
    }

    IEventManager off(
        /* callable */
        string eventKey, /* IEventListener|callable */
        // TODO callable aCallable = null
    ) {
        /*    if (!isString(eventKey)) {
        _listeners.keys.each!(name => off(name, eventKey)); 
        return this;
    }
 */ 
        /*    if (aCallable.isNull) {
        _listeners.removeKey(eventKey);

        return this;
    } */
        /*    if (_listeners.isEmpty(eventKey)) {
        return this;
    }
 */ /*    aCallable = aCallable(...);
    foreach (_listeners[eventKey] as priority : aCallables) {
        foreach (aCallables as myKey : aCallback) {
            if (aCallback["callable"] == aCallable) {
                _listeners.removePath([eventKey, priority, myKey]);
                break;
            }
        }
    }
 */
        return this;
    }

    // Auxiliary auto to help detach all listeners provided by an object implementing IEventListener
    protected void _detachSubscriber(IEventListener subscriber, string eventKey = null) {
        // TODO
        /*    events = subscriber.implementedEvents();
    if (!eventKey.isEmpty && events.isEmpty(eventKey)) {
        return;
    }
    if (!eventKey.isEmpty) {
        events = [eventKey: events[eventKey]];
    }
 */ /*    foreach (events as aKey : handlers) {
        foreach (thandler; his.normalizeHandlers(subscriber, handlers)) {
            this.off(aKey, handler["callable"]);
        }
    }
 */
    }

    /**
     * Builds an array of normalized handlers.
     *
     * A normalized handler is an aray with these keys:
     *
     * - `callable` - The event handler closure
     * - `settings` - The event handler settings
     */
    protected Json[string] normalizeHandlers(IEventListener subscriber, Json[string] eventHandlers) {
        if (!eventHandlers.hasKey("callable")) {
/*            eventHandlers.byKeyValue
                .each!(kv => eventHandlers[kv.key] = normalizeHandler(subscriber, kv.value));
 */        }
        return eventHandlers;
    }

/*     protected Json[string] normalizeHandlers(IEventListener subscriber, DClosure eventHandler) {
        // TODO return [normalizeHandler(subscriber, eventHandler)];
        return null; 
    }
 */
    protected Json[string] normalizeHandlers(IEventListener subscriber, /* Closure |  */ string eventHandler) {
        // TODO return [normalizeHandler(subscriber, eventHandler)];
        return null; 
    }

    /**
     * Builds a single normalized handler.
     *
     * A normalized handler is an array with these keys:
     *
     * - `callable` - The event handler closure
     * - `settings` - The event handler settings
     */
    protected Json[string] normalizeHandler(IEventListener subscriber, /* Closure|array| */ string eventHandler) {
        // auto callable = eventHandler;
        auto settings = null;

        /* if (isArray(eventHandler)) {
        // callable = eventHandler["callable"];

        settings = eventHandler;
        settings.removeKey("callable");
    } */
        // TODO
        /*    if (isString(aCallable)) {
        aCallable = subscriber.aCallable(...);
    }
 */
        // TODO return ["callable": aCallable, "settings": settings];
        return null;
    }

    IEvent dispatch(string eventName) {
        return dispatch(new DEvent(eventName));
    }

    IEvent dispatch(IEvent event) {
        auto listeners = listeners(event.name);
        if (_canAddEvents) {
            this.addEventToList(event);
        }
        if (!_isGlobal && instance().isTrackingEvents()) {
            instance().addEventToList(event);
        }
        if (isEmpty(listeners)) {
            return event;
        }
        /*    foreach (listener; listeners) {
        if (event.isStopped()) {
            break;
        }
        result = _callListener(listener["callable"], event);
        if (result == false) {
            event.stopPropagation();
        }
        if (!result.isNull) {
            event.setResult(result);
        }
    }
 */
        return event;
    }

    // Calls a listener.
    /* protected Json _callListener(callable listenerToTrigger, IEvent event) {
    // TODO 
/*    return listener(event, ...event.getData().values);
 * /
 }
 */

    Json[string] listeners(string eventKey) {
        // TODO 
        // auto localListeners = null;
        /*    if (!_isGlobal) {
        localListeners = prioritisedListeners(eventKey);
        localListeners = localListeners.isEmpty ? [] : localListeners;
    }
 * /    
    auto globalListeners = instance().prioritisedListeners(eventKey);
    globalListeners = empty(globalListeners) ? [] : globalListeners;

    priorities = array_merge(globalListeners.keys, localListeners.keys).unique;
    asort(priorities);

/*    auto result;
    foreach (priorities as priority) {
        if (globalListeners.hasKey(priority)) {
            result = array_merge(result, globalListeners[priority]);
        }
        if (localListeners.hasKey(priority)) {
            result = array_merge(result, localListeners[priority]);
        }
    }
    return result;
 */
        return null;
    }

    // Returns the listeners for the specified event key indexed by priority
    Json[string] prioritisedListeners(string key) {
        // return _listeners.get(key);
        return null;
    }

    // Returns the listeners matching a specified pattern
    Json[string] matchingListeners(string patternToPattern) {
        /*    matchPattern = "/" ~ preg_quote(eventKeyPattern, "/") ~ "/";

    return intersectinternalKey(
        _listeners,
        array_flip(
            preg_grep(matchPattern, _listeners.keys, 0) ?  : []
    )
    );
 */
        return null;
    }

    // Returns the event list.
    DEventList getEventList() {
        return _eventList;
    }

    // Adds an event to the list if the event list object is present.
    void addEventToList(IEvent event) {
        /*    _eventList ? .add(event);
 */
    }

    // Enables / disables event tracking at runtime.
    void canAddEvents(bool enabled) {
        _canAddEvents = enabled;
    }

    // Returns whether this manager is set up to track events
    bool isTrackingEvents() {
        // TODO return _canAddEvents && _eventList;
        return false;
    }

    // Enables the listing of dispatched events.
    void eventList(DEventList eventList) {
        _eventList = eventList;
        _canAddEvents = true;
    }

    // Disables the listing of dispatched events.
    void removeEventList() {
        _eventList = null;
        _canAddEvents = false;
    }

    // Debug friendly object properties.
    Json[string] debugInfo() {
        /*    properties = get_object_vars(this);
    properties.set("_generalManager", "(object) EventManager");
    properties.set("_listeners", null);
 */ /*    foreach (_listeners as aKey : priorities) {
        listenerCount = 0;
        foreach (priorities as listeners) {
            listenerCount += count(listeners);
        }
        properties["_listeners"][aKey] = listenerCount ~ " listener(s)";
    }
 */
        if (_eventList) {
            // TODO auto count = count(_eventList);
            /* for (index = 0; index < count; index++) {
                assert(!empty(_eventList[index]), "Given event item not present");

                event = _eventList[index];
                /*            try {
                subject = event.getSubject();
                properties["_dispatchedEvents").concat( event.name ~ " with subject " ~ subject
                    .classname;
            } catch (DException) {
                properties["_dispatchedEvents").concat( event.name ~ " with no subject";
            }
        } */
        } else {
            // properties["_dispatchedEvents"] = null;
        }

        /*    properties.removeKey("_eventList");

    return properties;
 */
        return null;
    }
}
