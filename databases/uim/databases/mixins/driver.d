module uim.databases.mixins.driver;

import uim.databases;

@safe:

string driverThis(string name) {
    string fullName = name~"Driver";
    return `
this() { super(); this.name("`~fullName~`"); }
    `;
}

template DriverThis(string name) {
    const char[] DriverThis = driverThis(name);
}

string driverCalls(string name) {
    string fullName = name~"Driver";
    return `
auto `~fullname~`() { return new D`~fullName~`(); }
    `;
}

template DriverCalls(string name) {
    const char[] DriverCalls = driverCalls(name);
}