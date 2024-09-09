module uim.views.mixins.templater;

import uim.views;
@safe: 

string templaterThis(string name = null) {
    string fullName = name ~ "Templater";
    return objThis(fullName);
}

template TemplaterThis(string name = null) {
    const char[] TemplaterThis = templaterThis(name);
}

string templaterCalls(string name) {
    string fullName = name ~ "Templater";
    return objCalls(fullName);
}

template TemplaterCalls(string name) {
    const char[] TemplaterCalls = templaterCalls(name);
}
