module uim.databastatementses.mixins.query;

string queryThis(string name) {
    string fullName = name ~ "Query";
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

template QueryThis(string name) {
    const char[] QueryThis = queryThis(name);
}

string queryCalls(string name) {
    string fullName = name ~ "Query";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(IData[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    `;
}

template QueryCalls(string name) {
    const char[] QueryCalls = queryCalls(name);
}