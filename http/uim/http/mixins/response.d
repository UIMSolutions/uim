module uim.http.mixins.response;

string responseThis(string name) {
    auto fullname = name~"Response";
    return `
this() {
    initialize(); this.name("`~fullname~`");
}
this(string name) {
    this(); this.name(name);
}
    `;    
}

template ResponseThis(string name) {
    const char[] ResponseThis = responseThis(name);
}

string responseCalls(string name) {
    auto fullname = name~"Response";
    return `
auto `~fullname~`() { return new D`~fullname~`(); }
auto `~fullname~`(string name) { return new D`~fullname~`(name); }
    `;    
}

template ResponseCalls(string name) {
    const char[] ResponseCalls = responseCalls(name);
}