module uim.events.classes.events.manager;

import uim.events;

@safe:

/**
 * The event manager is responsible for keeping track of event listeners, passing the correct
 * data to them, and firing them in the correct order, when associated events are triggered. You
 * can create multiple instances of this object to manage local events or keep a single instance
 * and pass it around to manage all events in your app.
 */
class DEventManager { // }: IEventManager {
    // The default priority queue value for new, attached listeners
    static int _defaultPriority = 10;

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
     * Params:
     * \UIM\Event\EventManager|null manager Event manager instance.
     */
    static DEventManager instance(DEventManager manager = null) {
        if (cast(DEventManager) manager) {
            _generalManager = manager;
        }
        /* if (_generalManager.isEmpty) {
            _generalManager = new static();
        } */
        _generalManager._isGlobal = true;

        return _generalManager;
    }

    void on( /* DEventListener |  */ string aeventKey, /* callable | */
        Json[string] options = null, /* callable callable = null */

    

    ) {
        // TODO
        /*         if (cast(DEventListener)eventKey) {
           _attachSubscriber(eventKey);

            return;
        }
        if (!aCallable && !isCallable(options)) {
            throw new DInvalidArgumentException(
                "second argument of `EventManager.on()` must be a callable if `aCallable`.isNull."
           );
        }
        if (!aCallable) {
            /** @var callable options */
        /*         _listeners[eventKey][defaultPriority] ~= [
            "callable": options(...),
        ];

        return;
    }

    priority = options["priority"] ?  ? defaultPriority;
    _listeners[eventKey][priority] ~= [
        "callable": aCallable(...),
    ]; */
    }

    /**
     * Auxiliary auto to attach all implemented callbacks of a UIM\Event\DEventListener class instance
     * as individual methods on this manager
     */
    protected void _attachSubscriber(DEventListener subscriber) {
        /*     foreach (eventKey : handlers; subscriber.implementedEvents()) {
        foreach (this.normalizeHandlers(subscriber, handlers) as handler) {
            this.on(eventKey, handler["settings"], handler["callable"]);
        }
    }
 */
    }

    void off(DEventListener listener
    ) {
        _detachSubscriber(listener);
    }

    auto off(
        /* |callable */
        string aeventKey, /* DEventListener|callable */
        // TODO callable aCallable = null

        

    ) {
        /*     if (!isString(eventKey)) {
        _listeners.keys.each!(name => off(name, eventKey)); 
        return this;
    }
 */ /* if (cast(DEventListener) aCallable) {
        _detachSubscriber(aCallable, eventKey);

        return this;
    }
 */
        /*     if (aCallable.isNull) {
        remove(_listeners[eventKey]);

        return this;
    } */
        /*     if (_listeners[eventKey].isEmpty) {
        return this;
    }
 */ /*     aCallable = aCallable(...);
    foreach (_listeners[eventKey] as priority : aCallables) {
        foreach (aCallables as myKey : aCallback) {
            if (aCallback["callable"] == aCallable) {
                remove(_listeners[eventKey][priority][myKey]);
                break;
            }
        }
    }
 */
        return this;
    }

    /**
     * Auxiliary auto to help detach all listeners provided by an object implementing DEventListener
     * Params:
     * \UIM\Event\DEventListener subscriber the subscriber to be detached
     * @param string eventKey optional event key name to unsubscribe the listener from
     */
    protected void _detachSubscriber(DEventListener subscriber, string aeventKey = null) {
        // TODO
        /*     events = subscriber.implementedEvents();
    if (!eventKey.isEmpty && events.isEmpty(eventKey)) {
        return;
    }
    if (!eventKey.isEmpty) {
        events = [eventKey: events[eventKey]];
    }
 */ /*     foreach (events as aKey : handlers) {
        foreach (this.normalizeHandlers(subscriber, handlers) as handler) {
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
     * Params:
     * \UIM\Event\DEventListener subscriber Event subscriber
     * @param \Closure|array|string ahandlers Event handlers
     */
    protected Json[string] normalizeHandlers(DEventListener subscriber, Json[string] eventHandlers) {
        if (!eventHandlers.hasKey("callable")) {
/*             eventHandlers.byKeyValue
                .each!(kv => eventHandlers[kv.key] = normalizeHandler(subscriber, kv.value));
 */        }
        return eventHandlers;
    }

    protected Json[string] normalizeHandlers(DEventListener subscriber, /* Closure |  */ string eventHandler) {
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
     * Params:
     * \UIM\Event\DEventListener subscriber Event subscriber
     * @param \Closure|array|string ahandler Event eventHandler
     */
    protected Json[string] normalizeHandler(DEventListener subscriber, /* Closure|array| */ string eventHandler) {
        // auto callable = eventHandler;
        auto settings = null;

        /* if (isArray(eventHandler)) {
        // callable = eventHandler["callable"];

        settings = eventHandler;
        settings.remove("callable");
    } */
        // TODO
        /*     if (isString(aCallable)) {
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
        /*     foreach (listeners as listener) {
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

    /**
     * Calls a listener.
     *
     * @template TSubject of object
     * @param callable listener The listener to trigger.
     * @param \UIM\Event\IEvent<TSubject> event Event instance.
     */
    /* protected Json _callListener(callable listener, IEvent event) {
    // TODO 
/*     return listener(event, ...array_values(event.getData()));
 * /
 }
 */

    Json[string] listeners(string eventKey) {
        // TODO 
        // auto localListeners = null;
        /*     if (!_isGlobal) {
        localListeners = prioritisedListeners(eventKey);
        localListeners = localListeners.isEmpty ? [] : localListeners;
    }
 * /    
    auto globalListeners = instance().prioritisedListeners(eventKey);
    globalListeners = empty(globalListeners) ? [] : globalListeners;

    priorities = array_merge(globalListeners.keys, localListeners.keys);
    priorities = array_unique(priorities);
    asort(priorities);

/*     auto result;
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
        /*     matchPattern = "/" ~ preg_quote(eventKeyPattern, "/") ~ "/";

    return array_intersectinternalKey(
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

    /**
     * Adds an event to the list if the event list object is present.
     *
     * @template TSubject of object
     * @param \UIM\Event\IEvent<TSubject> event An event to add to the list.
     */
    void addEventToList(IEvent event) {
        /*     _eventList ? .add(event);
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
        /*     properties = get_object_vars(this);
    properties["_generalManager"] = "(object) EventManager";
    properties["_listeners"] = null;
 */ /*     foreach (_listeners as aKey : priorities) {
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
                /*             try {
                subject = event.getSubject();
                properties["_dispatchedEvents"] ~= event.name ~ " with subject " ~ subject
                    .class;
            } catch (DException) {
                properties["_dispatchedEvents"] ~= event.name ~ " with no subject";
            }
        } */
        } else {
            // properties["_dispatchedEvents"] = null;
        }

        /*     properties.remove("_eventList");

    return properties;
 */
        return null;
    }
}
