module uim.views.mixins.form;

string formThis(string name = null) {
    string fullName = name ~ "Form";
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

template FormThis(string name = null) {
    const char[] FormThis = formThis(name);
}

string formCalls(string name) {
    string fullName = name ~ "Form";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template FormCalls(string name) {
    const char[] FormCalls = formCalls(name);
}
