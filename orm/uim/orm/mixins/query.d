module uim.orm.mixins.query;

string queryThis(string name) {
    auto fullname = name~"Query";
    return `
this() {
    initialize(); this.name("`~fullname~`");
}
this(string name) {
    this(); this.name(name);
}
    `;    
}

template QueryThis(string name) {
    const char[] QueryThis = queryThis(name);
}

string queryCalls(string name) {
    auto fullname = name~"Query";
    return `
auto `~fullname~`() { return new D`~fullname~`(); }
auto `~fullname~`(string name) { return new D`~fullname~`(name); }
    `;    
}

template QueryCalls(string name) {
    const char[] QueryCalls = queryCalls(name);
}