module uim.css.mixins.css;

string cssThis(string name = null) {
    string fullName = name ~ "Css";
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

template CssThis(string name = null) {
    const char[] CssThis = cssThis(name);
}

string cssCalls(string name) {
    string fullName = name ~ "Css";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template CssCalls(string name) {
    const char[] CssCalls = cssCalls(name);
}
