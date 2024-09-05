module uim.models.mixins.element;

import uim.models;
@safe: 

string elementThis(string name = null) {
    string fullName = `"` ~ name ~ "Element" ~ `"`;
    return objThis(fullName);
}

template elementThis(string name = null) {
    const char[] elementThis = elementThis(name);
}

string elementCalls(string name) {
    string fullName = name ~ "Element";
    return objCalls(fullName);
}