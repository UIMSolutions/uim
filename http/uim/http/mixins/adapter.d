module uim.http.mixins.adapter;

string adapterThis(string name) {
    auto fullname = name~"Adapter";
    return `
this() {
    initialize(); this.name("`~fullname~`");
}
this(string name) {
    this(); this.name(name);
}
    `;    
}

template AdapterThis(string name) {
    const char[] AdapterThis = adapterThis(name);
}

string adapterCalls(string name) {
    auto fullname = name~"Adapter";
    return `
auto `~fullname~`() { return new D`~fullname~`(); }
auto `~fullname~`(string name) { return new D`~fullname~`(name); }
    `;    
}

template AdapterCalls(string name) {
    const char[] AdapterThis = adapterCalls(name);
}