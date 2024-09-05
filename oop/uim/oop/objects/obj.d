module uim.oop.objects.obj;

import uim.oop;

@safe:

class UIMObject : INamed {
    mixin TConfigurable;

    this() {
        initialize;
    }

    this(Json[string] initData) {
        this.initialize(initData);
    }

    this(string newName, Json[string] initData = null) {
        this(initData).name(newName);
    }

    bool initialize(Json[string] initData = null) {
        name("Attribute");

        configuration(MemoryConfiguration);
        configuration.set(initData);

        // _methodNames = [__traits(allMembers, typeof(this))];
        return true;
    }

    mixin(TProperty!("string", "name"));
    // mixin(TProperty!("string[]", "methodNames"));
    string[] methods() {
        return [__traits(allMembers, typeof(this))];
    }
    bool hasMethod(string name) {
        return methods.has(name);
    }

    Json[string] debugInfo() {
        Json[string] info;
        return info
            .set("name", name)
            .set("classname", this.classname);
    }
}

class test : UIMObject {
    string newMethod() {
        return null; 
    }
    override string[] methods() {
        return [__traits(allMembers, typeof(this))];
    }
}
unittest {
    assert(new UIMObject);
    auto obj = new UIMObject;
    writeln("UIMObject -> ", obj.methods);
    writeln("new Object -> ", (new test).methods);
}
