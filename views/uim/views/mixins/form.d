module uim.views.mixins.form;

import uim.views;
@safe: 

string formThis(string name = null) {
    string fullName = name ~ "Form";
    return objThis(fullName);
}

template FormThis(string name = null) {
    const char[] FormThis = formThis(name);
}

string formCalls(string name) {
    string fullName = name ~ "Form";
    return objCalls(fullName);
}

template FormCalls(string name) {
    const char[] FormCalls = formCalls(name);
}
