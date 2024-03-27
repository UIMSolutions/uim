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

template DContextThis(string name) {
    const char[] DContextThis = contextThis(name);
}

string contextCalls(string name) {
    string fullName = name ~ "Context";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(IData[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template DContextCalls(string name) {
    const char[] DContextCalls = contextCalls(name);
}