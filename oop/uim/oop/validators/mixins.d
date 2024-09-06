module uim.oop.validators.mixins;

import uim.oop;
@safe: 

string validatorThis(string name = null) {
    string fullName = `"` ~ name ~ "Validator" ~ `"`;
    return objThis(fullName);
}

template ValidatorThis(string name = null) {
    const char[] ValidatorThis = validatorThis(name);
}

string validatorCalls(string name) {
    string fullName = name ~ "Validator";
    return objCalls(fullName);
}

template ValidatorCalls(string name) {
    const char[] ValidatorCalls = validatorCalls(name);
}