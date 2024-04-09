module uim.events.mixins.event;

string eventThis(string name) {
    string fullName = name ~ "Event";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(string name) {
        super(); this.name(name);
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
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template EventCalls(string name) {
    const char[] EventCalls = eventCalls(name);
}
