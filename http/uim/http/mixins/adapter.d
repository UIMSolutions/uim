module uim.http.mixins.adapter;

string adapterThis(string name = null) {
    string fullName = `"` ~ name ~ "Adapter"~`"`;
    return `
    this() {
        super(`~ fullName ~ `);
    }
    this(Json[string] initData) {
        super(`~ fullName ~ `, initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }
    `;
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