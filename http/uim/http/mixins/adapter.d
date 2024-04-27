module uim.http.mixins.adapter;

string adapterThis(string name) {
    string fullName = name ~ "Adapter";
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

template AdapterThis(string name) {
    const char[] AdapterThis = adapterThis(name);
}

string adapterCalls(string name) {
    string fullName = name ~ "Adapter";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template AdapterCalls(string name) {
    const char[] AdapterCalls = adapterCalls(name);
}