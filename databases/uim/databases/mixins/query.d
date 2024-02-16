module databases.uim.databases.mixins.query;

import uim.databases;

@safe:

string queryThis(string name) {
    string fullName = name~"Query";
    return `
this() { super(); this.name("`~fullName~`"); }
    `;
}

template QueryThis(string name) {
    const char[] QueryThis = queryThis(name);
}

string queryCalls(string name) {
    string fullName = name~"Query";
    return `
auto `~fullname~`() { return new D`~fullName~`(); }
    `;
}

template QueryCalls(string name) {
    const char[] QueryCalls = queryCalls(name);
}