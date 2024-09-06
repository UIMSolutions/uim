module uim.i18n.mixins.loader;

string loaderThis(string name = null) {
    string fullName = `"` ~ name ~ "Loader" ~ `"`;
    return objThis(fullName);
}

template LoaderThis(string name = null) {
    const char[] LoaderThis = loaderThis(name);
}

string loaderCalls(string name) {
    string fullName = name ~ "Loader";
    return objCalls(fullName);
}

template LoaderCalls(string name) {
    const char[] LoaderCalls = loaderCalls(name);
}
