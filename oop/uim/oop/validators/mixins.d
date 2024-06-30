module uim.oop.validators.mixins;

string validatorThis(string name) {
    string fullName = name ~ "Validator";
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

template ValidatorThis(string name) {
    const char[] ValidatorThis = validatorThis(name);
}

string validatorCalls(string name) {
    string fullName = name ~ "Validator";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    auto `~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData);}
    auto `~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); }
    `;
}

template ValidatorCalls(string name) {
    const char[] ValidatorCalls = validatorCalls(name);
}