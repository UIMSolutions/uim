module uim.events.mixins.event;

string eventThis(string name) {
    string fullName = name ~ "Event";
    return `
    this() {
        super("`~ fullName ~ `");
    }
    this(Json[string] initData) {
        super("`~ fullName ~ `", initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    `;
}

template EventThis(string name) {
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
