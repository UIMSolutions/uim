module uim.views.mixins.view;

string viewThis(string name) {
    string fullName = name ~ "View";
    return `
    this() {
        super("`~ fullName ~ `");
    }
    this(string name) {
        super(name);
    }
    this(Json[string] initData) {
        super("`~ fullName ~ `", initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    `;
}

template ViewThis(string name) {
    const char[] ViewThis = viewThis(name);
}

string viewCalls(string name) {
    string fullName = name ~ "View";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template ViewCalls(string name) {
    const char[] ViewCalls = viewCalls(name);
}