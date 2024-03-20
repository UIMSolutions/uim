module uim.events.Event;

import uim.events;

@safe:
/*
use ArrayAccess;
use Countable; */
/**
 * The Event List
 *
 * @template-implements \ArrayAccess<int, \UIM\Event\IEvent>
 */
class EventList : ArrayAccess, Countable {
    /**
     * Events list
     */
    protected IEvent<object>[] _events = [];

    // Empties the list of dispatched events.
    void flush() {
       _events = [];
    }
    
    /**
     * Adds an event to the list when event listing is enabled.
     * Params:
     * \UIM\Event\IEvent<object> event An event to the list of dispatched events.
     */
    void add(IEvent event) {
       _events ~= event;
    }
    
    /**
     * Whether a offset exists
     *
     * @link https://secure.php.net/manual/en/arrayaccess.offsetexists.php
     * @param Json  anOffset An offset to check for.
     * @return bool True on success or false on failure.
     */
    bool offsetExists(Json anOffset) {
        return isSet(_events[anOffset]);
    }

    /**
     * Offset to retrieve
     *
     * @link https://secure.php.net/manual/en/arrayaccess.offsetget.php
     * @param Json  anOffset The offset to retrieve.
     * @return \UIM\Event\IEvent<object>|null
     */
    IEvent offsetGet(Json anOffset) {
        if (!this.offsetExists(anOffset)) {
            return null;
        }
        return _events[anOffset];
    }
    
    /**
     * Offset to set
     *
     * @link https://secure.php.net/manual/en/arrayaccess.offsetset.php
     * @param Json  anOffset The offset to assign the value to.
     * @param Json aValue The value to set.
     */
    void offsetSet(Json anOffset, Json aValue) {
       _events[anOffset] = aValue;
    }

    /**
     * Offset to unset
     *
     * @link https://secure.php.net/manual/en/arrayaccess.offsetunset.php
     * @param Json  anOffset The offset to unset.
     */
    void offsetUnset(Json  anOffset) {
        unset(_events[anOffset]);
    }

    /**
     * Count elements of an object
     *
     * @link https://secure.php.net/manual/en/countable.count.php
     * @return int The custom count as an integer.
     */
    size_t count() {
        return count(_events);
    }
    
    /**
     * Checks if an event is in the list.
     * Params:
     * string aName Event name.
     */
    bool hasEvent(string aName) {
        foreach (event; _events) {
            if (event.name == name) {
                return true;
            }
        }
        return false;
    }
}
