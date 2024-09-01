module uim.routings.mixins.route;

string routeThis(string name) {
    string fullName = name ~ "Route";
    return `
    this() {
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

template RouteThis(string name) {
    const char[] RouteThis = routeThis(name);
}

string routeCalls(string name) {
    string fullName = name ~ "Route";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template RouteCalls(string name) {
    const char[] RouteCalls = routeCalls(name);
}