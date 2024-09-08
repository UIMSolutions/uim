module uim.oop.mixins.obj;

@safe: 

string objThis(string name = null) {
    return `
        this() {
            writeln("this() /", this.classname);
            super(`~ name ~ `);
        }
        this(Json[string] initData) {
            writeln("this(Json[string] initData) /", this.classname);
            super(initData);
        }
        this(string name, Json[string] initData = null) {
            writeln("this(string newName, Json[string] initData) /", this.classname);
            super(name, initData);
        }

        override string[] memberNames() {
            return [__traits(allMembers, typeof(this))];
        }
    `;
}

string objCalls(string name) {
    return `
        auto `~ name ~ `() { return new D` ~ name ~ `(); }
        auto `~ name ~ `(Json[string] initData) { return new D` ~ name ~ `(initData); }
        auto `~ name ~ `(string name, Json[string] initData = null) { return new D` ~ name ~ `(name, initData); }
    `;
}