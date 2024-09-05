module uim.oop.mixins.obj;

string objThis(string name = null) {
    return `
        this() {
            super(`~ name ~ `);
        }
        this(Json[string] initData) {
            super(`~ name ~ `, initData);
        }
        this(string name, Json[string] initData = null) {
            super(name, initData);
        }
    `;
}

string objCalls(string name) {
    return `
        auto `~ name ~ `() { return new D` ~ name ~ `();}
        auto `~ name ~ `(Json[string] initData) { return new D` ~ name ~ `(initData);}
        auto `~ name ~ `(string name, Json[string] initData = null) { return new D` ~ name ~ `(name, initData); }
    `;
}