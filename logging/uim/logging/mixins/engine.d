module uim.logging.mixins.engine;

string logEngineThis(string name) {
    string fullName = name ~ "LogEngine";
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

template LogEngineThis(string name) {
    const char[] LogEngineThis = logEngineThis(name);
}

string logEngineCalls(string name) {
    string fullName = name ~ "LogEngine";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template LogEngineCalls(string name) {
    const char[] LogEngineCalls = logEngineCalls(name);
}