module uim.routings.mixins.route;

string routeThis(string name) {
    string fullName = name ~ "Route";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(IData[string] initData) {
        super(initData); this.name("`~ fullName ~ `");
    }
    this(string name) {
        super(); this.name(name);
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
    auto `~ fullName ~ `(IData[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template RouteCalls(string name) {
    const char[] RouteCalls = routeCalls(name);
}