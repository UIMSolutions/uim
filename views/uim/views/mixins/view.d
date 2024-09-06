module uim.views.mixins.view;

import uim.views;
@safe: 

string viewThis(string name = null) {
    string fullName = `"` ~ name ~ "View" ~ `"`;
    return objThis(fullName);
}

template ViewThis(string name = null) {
    const char[] ViewThis = viewThis(name);
}

string viewCalls(string name) {
    string fullName = name ~ "View";
    return objCalls(fullName);
}

template ViewCalls(string name) {
    const char[] ViewCalls = viewCalls(name);
}