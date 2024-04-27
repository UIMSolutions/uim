module uim.databases.mixins.driver;

string driverThis(string name) {
    string fullName = name ~ "Driver";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(Json[string] initData) {
        super(initData); this.name("`~ fullName ~ `");
    }
    this(string name) {
        super(); this.name(name);
    }
    `;
}

template DriverThis(string name) {
    const char[] DriverThis = driverThis(name);
}

string driverCalls(string name) {
    string fullName = name ~ "Driver";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template DriverCalls(string name) {
    const char[] DriverCalls = driverCalls(name);
}