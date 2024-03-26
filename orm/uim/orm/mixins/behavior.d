module uim.orm.mixins.behavior;

string behaviorThis(string name) {
    string fullName = name ~ "Behavior";
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

template BehaviorThis(string name) {
    const char[] BehaviorThis = behaviorThis(name);
}

string behaviorCalls(string name) {
    string fullName = name ~ "Behavior";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(IData[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template BehaviorCalls(string name) {
    const char[] BehaviorCalls = behaviorCalls(name);
}