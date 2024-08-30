module uim.views.mixins.form;

string formThis(string name) {
    string fullName = name ~ "Form";
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

template FormThis(string name) {
    const char[] FormThis = formThis(name);
}

string formCalls(string name) {
    string fullName = name ~ "Form";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template FormCalls(string name) {
    const char[] FormCalls = formCalls(name);
}
