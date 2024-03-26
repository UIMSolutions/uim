module uim.orm.mixins.locator;

string locatorThis(string name) {
    string fullName = name ~ "Locator";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(IData[string] initData) {
        super(initData); this.name("`~ fullName ~ `");
    }
    this(string name) {
        super(); this.name(name);
    }
    `;
}

template LocatorThis(string name) {
    const char[] LocatorThis = locatorThis(name);
}

string locatorCalls(string name) {
    string fullName = name ~ "Locator";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(IData[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template LocatorCalls(string name) {
    const char[] LocatorCalls = locatorCalls(name);
}