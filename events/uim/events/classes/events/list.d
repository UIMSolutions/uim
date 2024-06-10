module uim.events.classes.events.list;

import uim.events;

@safe:
/**
 * The Event List
 *
 * @template-implements \ArrayAccess<int, \UIM\Event\IEvent>
 */
class DEventList { // }: ArrayAccess, Countable {
    // Events list
    protected IEvent[] _events = null;

    // Empties the list of dispatched events.
    void flush() {
        _events = null;
    }

    // Adds an event to the list when event listing is enabled.
    void add(IEvent event) {
        _events ~= event;
    }

    // Whether a offset exists
    bool offsetExists(Json anOffset) {
        // TODO return _events.hasValue(anOffset);
        return false;
    }

    /**
     * Offset to retrieve
     * @param Json anOffset The offset to retrieve.
     */
    IEvent offsetGet(Json anOffset) {
        /* return offsetExists(anOffset)
            ? _events[anOffset] : null; */
            return null; 
    }

    // Offset to set
    void offsetSet(string offset, Json value) {
        // _events[offset] = value;
    }

    // Offset to unset
    void offsetUnset(string offset) {
        _events.remove(offset);
    }

    // Count elements of an object
    size_t count() {
        return _events.length;
    }

    // Checks if an event is in the list.
    bool hasEvent(string eventName) {
        return _events.any!(event => event.name == eventName);
    }
}
