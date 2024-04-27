module uim.views.mixins.helper;

string helperThis(string name) {
    string fullName = name ~ "Helper";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(Json[string] initData) {
        super(initData); this.name("`~ fullName ~ `");
    }
    this(string name) {
        super(); this.name(name);
    }
    `;
}

template HelperThis(string name) {
    const char[] HelperThis = helperThis(name);
}

string helperCalls(string name) {
    string fullName = name ~ "Helper";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template HelperCalls(string name) {
    const char[] HelperCalls = helperCalls(name);
}