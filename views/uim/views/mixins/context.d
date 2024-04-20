module uim.views.mixins.context;

string contextThis(string name) {
    string fullName = name ~ "Context";
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

template ContextThis(string name) {
    const char[] ContextThis = contextThis(name);
}

string contextCalls(string name) {
    string fullName = name ~ "Context";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(IData[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template ContextCalls(string name) {
    const char[] ContextCalls = contextCalls(name);
}