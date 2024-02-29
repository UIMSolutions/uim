module uim.http.mixins.request;

string requestThis(string name) {
    auto fullname = name~"Request";
    return `
this() {
    initialize(); this.name("`~fullname~`");
}
this(string name) {
    this(); this.name(name);
}
    `;    
}

template RequestThis(string name) {
    const char[] RequestThis = requestThis(name);
}

string requestCalls(string name) {
    auto fullname = name~"Request";
    return `
auto `~fullname~`() { return new D`~fullname~`(); }
auto `~fullname~`(string name) { return new D`~fullname~`(name); }
    `;    
}

template RequestCalls(string name) {
    const char[] RequestThis = requestCalls(name);
}