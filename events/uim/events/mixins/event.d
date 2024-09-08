module uim.events.mixins.event;

import uim.events;
@safe: 

string eventThis(string name = null) {
    string fullName = name ~ "Event";
    return objThis(fullName);
}

template EventThis(string name = null) {
    const char[] EventThis = eventThis(name);
}

string eventCalls(string name) {
    string fullName = name ~ "Event";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template EventCalls(string name) {
    const char[] EventCalls = eventCalls(name);
}
