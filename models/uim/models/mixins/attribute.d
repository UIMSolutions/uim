module uim.models.mixins.attribute;

string attributeThis(string name) {
    string fullName = name ~ "attribute";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    this(Json[string] initData) {
        super(initData); this.name("`~ fullName ~ `");
    }
    this(string name) {
        this(); this.name(name);
    }
    this(string name, Json[string] initData) {
        this(name).initialize(initData);
    }
    `;
}

template attributeThis(string name) {
    const char[] attributeThis = attributeThis(name);
}

string attributeCalls(string name) {
    string fullName = name ~ "attribute";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name) { return new D` ~ fullName ~ `(name); }
    auto `~ fullName ~ `(string name, Json[string] initData) { return new D` ~ fullName ~ `(name, initData); }
    `;
}