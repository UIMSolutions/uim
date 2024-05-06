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
    // TODO protected IEventList _eventList = null;

    // Internal flag to distinguish a common manager from the singleton
    protected bool _isGlobal = false;

    // Enables automatic adding of events to the event list object if it is present.
    protected bool _canAddEvents = false;

    // The globally available instance, used for dispatching events attached from any scope
    protected static DEventManager _generalManager = null;

    // List of listener callbacks associated to
    // TODO protected Json[string] _listeners = null;

    /**
     * Returns the globally available instance of a UIM\Event\EventManager
     * this is used for dispatching events attached from outside the scope
     * other managers were created. Usually for creating hook systems or inter-class
     * communication
     *
     * If called with the first parameter, it will be set as the globally available instance
     * Params:
     * \UIM\Event\EventManager|null manager Event manager instance.
     * @return \UIM\Event\EventManager The global event manager
     * /
    static auto instance(?EventManager manager = null): EventManager {
        if (cast(DEventManager)manager) {
            _generalManager = manager;
        }
        if (_generalManager.isEmpty) {
            _generalManager = new static();
        }
        _generalManager._isGlobal = true;

        return _generalManager;
    }
 
    
        void on(IEventListener|string aeventKey,
        callable|Json[string] options = null,
        ?callable callable = null
    ) {
        if (cast(IEventListener)eventKey) {
           _attachSubscriber(eventKey);

            return;
        }
        if (!aCallable && !isCallable(options)) {
            throw new DInvalidArgumentException(
                "second argument of `EventManager.on()` must be a callable if `aCallable`.isNull."
            );
        }
        if (!aCallable) {
            /** @var callable options * /
           _listeners[eventKey][defaultPriority] ~= [
                "callable": options(...),
            ];

            return;
        }
        priority = options["priority"] ?? defaultPriority;
       _listeners[eventKey][priority] ~= [
            "callable": aCallable(...),
        ];
    }

    /**
     * Auxiliary auto to attach all implemented callbacks of a UIM\Event\IEventListener class instance
     * as individual methods on this manager
     * /
    protected void _attachSubscriber(IEventListener subscriber) {
        foreach (eventKey: handlers; subscriber.implementedEvents()) {
            foreach (this.normalizeHandlers(subscriber, handlers) as handler) {
                this.on(eventKey, handler["settings"], handler["callable"]);
            }
        }
    }
 
    auto off(
        IEventListener|callable|string aeventKey,
        IEventListener|callable|null aCallable = null
    ) {
        if (cast(IEventListener)eventKey) {
           _detachSubscriber(eventKey);

            return this;
        }
        if (!isString(eventKey)) {
            foreach (_listeners.keys as name) {
                this.off(name, eventKey);
            }
            return this;
        }
        if (cast(IEventListener)aCallable) {
           _detachSubscriber(aCallable, eventKey);

            return this;
        }
        if (aCallable.isNull) {
            unset(_listeners[eventKey]);

            return this;
        }
        if (_listeners[eventKey].isEmpty) {
            return this;
        }
        aCallable = aCallable(...);
        foreach (_listeners[eventKey] as priority: aCallables) {
            foreach (aCallables as myKey: aCallback) {
                if (aCallback["callable"] == aCallable) {
                    unset(_listeners[eventKey][priority][myKey]);
                    break;
                }
            }
        }
        return this;
    }

    /**
     * Auxiliary auto to help detach all listeners provided by an object implementing IEventListener
     * Params:
     * \UIM\Event\IEventListener subscriber the subscriber to be detached
     * @param string|null eventKey optional event key name to unsubscribe the listener from
     * /
    protected void _detachSubscriber(IEventListener subscriber, string aeventKey = null) {
        events = subscriber.implementedEvents();
        if (!empty(eventKey) && empty(events[eventKey])) {
            return;
        }
        if (!empty(eventKey)) {
            events = [eventKey: events[eventKey]];
        }
        foreach (events as aKey: handlers) {
            foreach (this.normalizeHandlers(subscriber, handlers) as handler) {
                this.off(aKey, handler["callable"]);
            }
        }
    }

    /**
     * Builds an array of normalized handlers.
     *
     * A normalized handler is an aray with these keys:
     *
     * - `callable` - The event handler closure
     * - `settings` - The event handler settings
     * Params:
     * \UIM\Event\IEventListener subscriber Event subscriber
     * @param \Closure|array|string ahandlers Event handlers
     * /
    // TODO protected Json[string] normalizeHandlers(IEventListener subscriber, Closure|array|string ahandlers) {
        // Check if an array of handlers not single handler config array
        if (isArray(handlers) && !isSet(handlers["callable"])) {
            foreach (handlers as &handler) {
                handler = this.normalizeHandler(subscriber, handler);
            }
            return handlers;
        }
        return [this.normalizeHandler(subscriber, handlers)];
    }

    /**
     * Builds a single normalized handler.
     *
     * A normalized handler is an array with these keys:
     *
     * - `callable` - The event handler closure
     * - `settings` - The event handler settings
     * Params:
     * \UIM\Event\IEventListener subscriber Event subscriber
     * @param \Closure|array|string ahandler Event handler
     * /
<<<<<<< HEAD
    // TODO protected Json[string] normalizeHandler(IEventListener subscriber, Closure|array|string ahandler) {
        callable = handler;
        settings = null;

        if (isArray(handler)) {
            callable = handler["callable"];

            settings = handler;
            unset(settings["callable"]);
        }
<<<<<<< HEAD
        if (isString(callable)) {
            callable = subscriber.callable(...);
=======
        if (isString(aCallable)) {
            aCallable = subscriber.aCallable(...);
>>>>>>> 6c77f0755345c40125ff261f87e4ab75fc24b38d
        }
        return ["callable": aCallable, "settings": settings];
    }
 
    IEvent dispatch(IEvent|string aevent) {
        if (isString(event)) {
            event = new DEvent(event);
        }
        listeners = this.listeners(event.name);

        if (_canAddEvents) {
            this.addEventToList(event);
        }
        if (!_isGlobal && instance().isTrackingEvents()) {
            instance().addEventToList(event);
        }
        if (isEmpty(listeners)) {
            return event;
        }
        foreach (listeners as listener) {
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
        return event;
    }
    
    /**
     * Calls a listener.
     *
     * @template TSubject of object
     * @param callable listener The listener to trigger.
     * @param \UIM\Event\IEvent<TSubject> event Event instance.
     * @return Json The result of the listener function.
     * /
    protected Json _callListener(callable listener, IEvent event) {
        return listener(event, ...array_values(event.getData()));
    }
 
    array listeners(string aeventKey) {
        localListeners = null;
        if (!_isGlobal) {
            localListeners = this.prioritisedListeners(eventKey);
            localListeners = empty(localListeners) ? [] : localListeners;
        }
        globalListeners = instance().prioritisedListeners(eventKey);
        globalListeners = empty(globalListeners) ? [] : globalListeners;

        priorities = array_merge(globalListeners.keys, localListeners.keys);
        priorities = array_unique(priorities);
        asort(priorities);

        auto result;
        foreach (priorities as priority) {
            if (isSet(globalListeners[priority])) {
                result = array_merge(result, globalListeners[priority]);
            }
            if (isSet(localListeners[priority])) {
                result = array_merge(result, localListeners[priority]);
            }
        }
        return result;
    }
    
    /**
     * Returns the listeners for the specified event key indexed by priority
     * Params:
     * string aeventKey Event key.
     * /
    array prioritisedListeners(string aeventKey) {
        if (isEmpty(_listeners[eventKey])) {
            return null;
        }
        return _listeners[eventKey];
    }
    
    /**
     * Returns the listeners matching a specified pattern
     * Params:
     * string aeventKeyPattern Pattern to match.
     * /
    array matchingListeners(string aeventKeyPattern) {
        matchPattern = "/" ~ preg_quote(eventKeyPattern, "/") ~ "/";

        return array_intersect_key(
           _listeners,
            array_flip(
                preg_grep(matchPattern, _listeners.keys, 0) ?: []
            )
        );
    }
    
    /**
     * Returns the event list.
     *
     * @return \UIM\Event\EventList|null
     * /
    EventList getEventList(): 
    {
        return _eventList;
    }
    
    /**
     * Adds an event to the list if the event list object is present.
     *
     * @template TSubject of object
     * @param \UIM\Event\IEvent<TSubject> event An event to add to the list.
     * /
    auto addEventToList(IEvent event) {
       _eventList?.add(event);

        return this;
    }
    
    /**
     * Enables / disables event tracking at runtime.
     * Params:
     * bool enabled True or false to enable / disable it.
     * /
    auto canAddEvents(bool enabled) {
       _canAddEvents = enabled;

        return this;
    }
    
    /**
     * Returns whether this manager is set up to track events
     * /
    bool isTrackingEvents() {
        return _canAddEvents && _eventList;
    }
    
    /**
     * Enables the listing of dispatched events.
     * Params:
     * \UIM\Event\EventList eventList The event list object to use.
     * /
    auto setEventList(EventList eventList) {
       _eventList = eventList;
       _canAddEvents = true;

        return this;
    }
    
    // Disables the listing of dispatched events.
    void unsetEventList() {
       _eventList = null;
       _canAddEvents = false;
    }
    
    // Debug friendly object properties.
    Json[string] debugInfo() {
        properties = get_object_vars(this);
        properties["_generalManager"] = "(object) EventManager";
        properties["_listeners"] = null;
        foreach (_listeners as aKey: priorities) {
            listenerCount = 0;
            foreach (priorities as listeners) {
                listenerCount += count(listeners);
            }
            properties["_listeners"][aKey] = listenerCount ~ " listener(s)";
        }
        if (_eventList) {
            count = count(_eventList);
            for (anI = 0;  anI < count;  anI++) {
                assert(!empty(_eventList[anI]), "Given event item not present");

                event = _eventList[anI];
                try {
                    subject = event.getSubject();
                    properties["_dispatchedEvents"] ~= event.name ~ " with subject " ~ subject.class;
                } catch (UimException) {
                    properties["_dispatchedEvents"] ~= event.name ~ " with no subject";
                }
            }
        } else {
            properties["_dispatchedEvents"] = null;
        }
        unset(properties["_eventList"]);

        return properties;
    } */
}
