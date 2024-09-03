module uim.views.mixins.helper;

string helperThis(string name = null) {
    string fullName = name ~ "Helper";
    return `
    this() {
        super("`~ fullName ~ `");
    }
    this(Json[string] initData) {
        super("`~ fullName ~ `", initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    `;
}

template HelperThis(string name = null) {
    const char[] HelperThis = helperThis(name);
}

string helperCalls(string name) {
    string fullName = name ~ "Helper";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template HelperCalls(string name) {
    const char[] HelperCalls = helperCalls(name);
}