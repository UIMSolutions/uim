module uim.http.mixins.response;

string responseThis(string name = null) {
    string fullName = `"` ~ name ~ "Response" ~ `"`;
    return objThis(fullName);
}

template ResponseThis(string name = null) {
    const char[] ResponseThis = responseThis(name);
}

string responseCalls(string name) {
    string fullName = name ~ "Response";
    return objCalls(fullName);
}

template ResponseCalls(string name) {
    const char[] ResponseCalls = responseCalls(name);
}