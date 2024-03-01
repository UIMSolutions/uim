module controllers.uim.controllers.tests.controller;

string controllerThis(string name) {
    string fullName = name ~ "Controller";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(string name) {
        super(); this.name(name);
    }
    `;
}

template ControllerThis(string name) {
    const char[] ControllerThis = controllerThis(name);
}

string controllerCalls(string name) {
    string fullName = name ~ "Controller";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template ControllerCalls(string name) {
    const char[] ControllerCalls = controllerCalls(name);
}
