module uim.controllers.mixins.controller;

string controllerThis(string name = null) {
    string fullName = name ~ "Controller";
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

template ControllerThis(string name = null) {
    const char[] ControllerThis = controllerThis(name);
}

string controllerCalls(string name) {
    string fullName = name ~ "Controller";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template ControllerCalls(string name) {
    const char[] ControllerCalls = controllerCalls(name);
}
