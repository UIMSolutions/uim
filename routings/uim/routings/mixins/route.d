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
    return objCalls(fullName);

template RouteCalls(string name) {
    const char[] RouteCalls = routeCalls(name);
}