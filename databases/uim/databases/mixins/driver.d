module uim.databases.mixins.driver;

import uim.databases;

@safe:

string driverThis(string name) {
    auto fullname = name~"Driver";
    return `
this(IData[string] initData = null) {
    initialize(initData); this.name("`~fullname~`");
}
this(string name) {
    this(); this.name(name);
}
    `;    
}

template DriverThis(string name) {
    const char[] DriverThis = driverThis(name);
}

string driverCalls(string name) {
    auto fullname = name~"Driver";
    return `
auto `~fullname~`() { return new D`~fullname~`(); }
auto `~fullname~`(string name) { return new D`~fullname~`(name); }
    `;    
}

template DriverCalls(string name) {
    const char[] DriverCalls = driverCalls(name);
}