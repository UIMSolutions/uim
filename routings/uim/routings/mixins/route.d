module uim.routings.mixins.route;

string routeThis(string name = null) {
    string fullName = `"` ~ name ~ "Route" ~ `"`;
    return objThis(fullName);
}

template RouteThis(string name = null) {
    const char[] RouteThis = routeThis(name);
}

string routeCalls(string name) {
    string fullName = name ~ "Route";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template RouteCalls(string name) {
    const char[] RouteCalls = routeCalls(name);
}