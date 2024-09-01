module uim.i18n.mixins.loader;

string loaderThis(string name) {
    string fullName = name ~ "Loader";
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

template LoaderThis(string name) {
    const char[] LoaderThis = loaderThis(name);
}

string loaderCalls(string name) {
    string fullName = name ~ "Loader";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template LoaderCalls(string name) {
    const char[] LoaderCalls = loaderCalls(name);
}