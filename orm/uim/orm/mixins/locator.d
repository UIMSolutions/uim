module orm.uim.orm.mixins.locator;

module uim.logging.mixins.locator;

string locatorThis(string name) {
    auto fullname = name~"Locator";
    return `
this() {
    initialize(); this.name("`~fullname~`");
}
this(string name) {
    this(); this.name(name);
}
    `;    
}

template LocatorThis(string name) {
    const char[] LocatorThis = locatorThis(name);
}

string locatorCalls(string name) {
    auto fullname = name~"Locator";
    return `
auto `~fullname~`() { return new D`~fullname~`(); }
auto `~fullname~`(string name) { return new D`~fullname~`(name); }
    `;    
}

template LocatorCalls(string name) {
    const char[] LocatorThis = locatorCalls(name);
}