module uim.css.mixins.css;

import uim.css;
@safe:

string cssThis(string name = null) {
    string fullName = `"` ~ name ~ "Css" ~ `"`;
    return objThis(fullName);
}

template CssThis(string name = null) {
    const char[] CssThis = cssThis(name);
}

string cssCalls(string name) {
    string fullName = name ~ "Css";
    return objCalls(fullName);
}

template CssCalls(string name) {
    const char[] CssCalls = cssCalls(name);
}
