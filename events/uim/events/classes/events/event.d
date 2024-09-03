module uim.events.classes.events.event;

import uim.events;

@safe:

class DEvent : UIMObject, IEvent {
    mixin(EventThis!());

    /**
     * ### Examples of usage:
     *
     * ```
     * event = new DEvent("Order.afterBuy", this, ["buyer": userData]);
     * event = new DEvent("User.afterRegister", userModel);
     * ```
     */
    this(string eventName, IEventObject subject = null, Json[string] data = null) {
        _name = eventName;
        _subject = subject;
        _data = dataToTransport;
    }

    // The object this event applies to (usually the same object that generates the event)
    protected IEventObject _subject = null;

    // Custom data for the method that receives the event
    protected Json[string] _data;

    // Property used to retain the result value of the event listeners
    mixin(TProperty!("Json", "result"));

    // Flags an event as stopped or not, default is false
    protected bool _isStopped = false;

    // Stops the event from being used anymore
    void stopPropagation() {
        _isStopped = true;
    }

    // Check if the event is stopped
    bool isStopped() {
        return _isStopped;
    }

    // Returns the subject of this event
    IEventObject getSubject() {
        if (_subject is null) {
            throw new DEventsException("No subject set for this event");
        }
        return _subject;
    }

    // #region data 
    Json opIndex(string key) {
        return data.get(key);
    }

    Json[string] data() {
        return _data;
    }

    Json data(string key) {
        return _data.get(key);
    }

    void opIndexAssign(Json value, string key) {
        data(key, value);
    }

    void data(string[] keys, Json value) {
        _data = _data.set(keys, value);
    }

    void data(string key, Json value) {
        _data = _data.set(key, value);
    }
    // #endregion data 
}
