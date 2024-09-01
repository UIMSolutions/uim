module uim.http.mixins.adapter;

string adapterThis(string name) {
    string fullName = name ~ "Adapter";
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

template AdapterThis(string name) {
    const char[] AdapterThis = adapterThis(name);
}

string adapterCalls(string name) {
    string fullName = name ~ "Adapter";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template AdapterCalls(string name) {
    const char[] AdapterCalls = adapterCalls(name);
}