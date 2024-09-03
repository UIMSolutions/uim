module uim.i18n.mixins.loader;

string loaderThis(string name = null) {
    string fullName = `"` ~ name ~ "Loader" ~ `"`;
    return `
    this() {
        super(`~ fullName ~ `);
    }
    this(Json[string] initData) {
        super(`~ fullName ~ `, initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    `;
}

template LoaderThis(string name = null) {
    const char[] LoaderThis = loaderThis(name);
}

string loaderCalls(string name) {
    string fullName = name ~ "Loader";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template LoaderCalls(string name) {
    const char[] LoaderCalls = loaderCalls(name);
}