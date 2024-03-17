module uim.caches.mixins.engine;

string engineThis(string name) {
    auto fullname = name~"Engine";
    return `
this() {
    initialize(); this.name("`~fullname~`");
}
this(string name) {
    this(); this.name(name);
}
    `;    
}

template EngineThis(string name) {
    const char[] EngineThis = engineThis(name);
}

string engineCalls(string name) {
    auto fullname = name~"Engine";
    return `
auto `~fullname~`() { return new D`~fullname~`(); }
auto `~fullname~`(string name) { return new D`~fullname~`(name); }
    `;    
}

template EngineCalls(string name) {
    const char[] EngineCalls = engineCalls(name);
}