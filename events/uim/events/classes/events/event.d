module uim.events.classes.events.event;

import uim.events;

@safe:

class DEvent : IEvent {
    this() {
        this.name(this.className);
    }

    this(string name) {
        this.name(name);
    }

    // Name of the event
    mixin(TProperty!("string", "name"));

    // The object this event applies to (usually the same object that generates the event)
    protected IEventObject _subject = null;

    // Custom data for the method that receives the event
    protected Json _data;

    // Property used to retain the result value of the event listeners
    // Get/Set the result value of the event listeners
    mixin(TProperty!("Json", "result"));

    // Flags an event as stopped or not, default is false
    protected bool _stopped = false;

    // Stops the event from being used anymore
    void stopPropagation() {
        _stopped = true;
    }

    // Check if the event is stopped
    bool isStopped() {
        return _stopped;
    }

    /**
     * Constructor
     *
     * ### Examples of usage:
     *
     * ```
     * event = new DEvent("Order.afterBuy", this, ["buyer": userData]);
     * event = new DEvent("User.afterRegister", userModel);
     * ```
     * Params:
     * @param object|null subject the object that this event applies to
     *  (usually the object that is generating the event).
     * @param array data any value you wish to be transported
     *  with this event to it can be read by listeners.
     * @psalm-param TSubject|null subject
     * /
    this(string eventName, IEventObject subject = null, Json data = null) {
        _name = eventName;
        _subject = subject;
        _data = data;
    }

    // Returns the subject of this event
    IEventObject getSubject() {
        if (_subject.isNull) {
            throw new DEventException("No subject set for this event");
        }
        return _subject;
    }



    // #region data handling
    Json opIndex(string key) {
        return data(string key);
    }

    @property Json data(string aKey) {
        if (aKey!isNull) {
            return _data[aKey] ?  ? null;
        }
        return _data;
    }

    void opIndexAssign(Json value, string key) {
        data(key, value);
    }

    @property void data(string aKey, Json aValue) {
        if (isArray(aKey)) {
            _data = aKey;
        } else {
            _data[aKey] = aValue;
        }
    }
    // #endregion data handling
    */
}
