module uim.orm.mixins.behavior;

import uim.orm;

@safe:
module uim.logging.mixins.behavior;

string behaviorThis(string name) {
    auto fullname = name~"Behavior";
    return `
this() {
    initialize(); this.name("`~fullname~`");
}
this(string name) {
    this(); this.name(name);
}
    `;    
}

template BehaviorThis(string name) {
    const char[] BehaviorThis = behaviorThis(name);
}

string behaviorCalls(string name) {
    auto fullname = name~"Behavior";
    return `
auto `~fullname~`() { return new D`~fullname~`(); }
auto `~fullname~`(string name) { return new D`~fullname~`(name); }
    `;    
}

template BehaviorCalls(string name) {
    const char[] BehaviorThis = behaviorCalls(name);
}