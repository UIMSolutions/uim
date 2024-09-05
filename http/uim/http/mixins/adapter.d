module uim.http.mixins.adapter;

string adapterThis(string name = null) {
    string fullName = `"` ~ name ~ "Adapter"~`"`;
    return objThis(fullName);
}

template AdapterThis(string name = null) {
    const char[] AdapterThis = adapterThis(name);
}

string adapterCalls(string name) {
    string fullName = name ~ "Adapter";
    return objCalls(fullName);
}

template AdapterCalls(string name) {
    const char[] AdapterCalls = adapterCalls(name);
}