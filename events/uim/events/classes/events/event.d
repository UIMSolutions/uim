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
     * ### Examples of usage:
     *
     * ```
     * event = new DEvent("Order.afterBuy", this, ["buyer": userData]);
     * event = new DEvent("User.afterRegister", userModel);
     * ```
     */
    this(string eventName, IEventObject subject = null, Json[string] dataToTransport = null) {
        _name = eventName;
        _subject = subject;
        _data = dataToTransport;
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

    @property Json data(string key) {
        return !aKey.isNull
            ? _data.get(aKey) : _data;
    }

    void opIndexAssign(Json value, string key) {
        data(key, value);
    }

    void data(string[] keys, Json aValue) {
        _data = keys;
    }

    void data(string key, Json value) {
        _data[key] = value;
    }

    // #endregion data handling

}
