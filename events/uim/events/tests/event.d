module uim.events.tests.event;

import uim.events;

@safe:

bool testEvent(IEvent eventToTest) {
    assert(eventToTest !is null, "In testEvent: eventToTest is null");
    
    return true;
}