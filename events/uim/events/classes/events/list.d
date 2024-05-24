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
    bool offsetExists(Json offsetToCheck) {
        return isSet(_events[offsetToCheck]);
    }

    // Offset to retrieve
    IEvent offsetGet(Json offsetToRetrieve) {
        if (!offsetExists(offsetToRetrieve)) {
            return null;
        }
        return _events[offsetToRetrieve];
    }
    
    // Offset to set
    void offsetSet(Json offsetToAssign, Json valueToSet) {
       _events[offsetToAssign] = valueToSet;
    }

    // Offset to unset
    void offsetUnset(Json offsetToUnset) {
        unset(_events[anOffset]);
    }

    // Count elements of an object
    size_t count() {
        return count(_events);
    }
    
    // Checks if an event is in the list.
    bool hasEvent(string eventName) {
        return _events.any!(event => event.name == eventName)
    }
}
