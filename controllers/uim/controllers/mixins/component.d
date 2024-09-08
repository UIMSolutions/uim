module uim.controllers.mixins.component;

import uim.controllers;

@safe:

string componentThis(string name = null) {
    string fullName = name ~ "Component";
    return objThis(fullName);

}

template ComponentThis(string name = null) {
    const char[] ComponentThis = componentThis(name);
}

string componentCalls(string name) {
    string fullName = name ~ "Component";
    return objCalls(fullName);
}

template ComponentCalls(string name) {
    const char[] ComponentCalls = componentCalls(name);
}
