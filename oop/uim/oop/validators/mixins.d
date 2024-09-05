module uim.oop.validators.mixins;

string validatorThis(string name = null) {
    string fullName = `"` ~ name ~ "Validator" ~ `"`;
    return objThis(fullName);
}

template ValidatorThis(string name = null) {
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