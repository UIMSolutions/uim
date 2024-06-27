module uim.models.mixins.element;

string elementThis(string name) {
    string fullName = name ~ "Element";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(Json[string] initData) {
        super(initData); this.name("`~ fullName ~ `");
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    `;
}

template elementThis(string name) {
    const char[] elementThis = elementThis(name);
}

string elementCalls(string name) {
    string fullName = name ~ "Element";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}