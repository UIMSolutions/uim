module uim.http.mixins.request;

string requestThis(string name) {
    string fullName = name ~ "Request";
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

template RequestThis(string name) {
    const char[] RequestThis = requestThis(name);
}

string requestCalls(string name) {
    string fullName = name ~ "Request";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template RequestCalls(string name) {
    const char[] RequestCalls = requestCalls(name);
}