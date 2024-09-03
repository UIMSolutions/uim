module uim.views.mixins.view;

string viewThis(string name = null) {
    string fullName = name ~ "View";
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

template ViewThis(string name = null) {
    const char[] ViewThis = viewThis(name);
}

string viewCalls(string name) {
    string fullName = name ~ "View";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template ViewCalls(string name) {
    const char[] ViewCalls = viewCalls(name);
}