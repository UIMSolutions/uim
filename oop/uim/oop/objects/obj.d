module uim.oop.objects.obj;

import uim.oop;

@safe:

class UIMObject : INamed {
    mixin TConfigurable;

    this() {
        writeln("UIMObject::this()", this.classname);
        this.initialize; 
    }

    this(Json[string] initData) {
        writeln("UIMObject::this(Json[string] initData)", this.classname);
        this.initialize(initData);
    }

    this(string newName, Json[string] initData = null) {
        writeln("UIMObject::this(string newName, Json[string] initData)", this.classname);
        this.name(newName);
        this.initialize(initData);
    }

    bool initialize(Json[string] initData = null) {
        name("Object");

        auto config = MemoryConfiguration;
        configuration(config);
        configuration.set(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));
    // mixin(TProperty!("string[]", "methodNames"));

    string[] memberNames() {
        return [__traits(allMembers, typeof(this))];
    }

    bool hasMember(string name) {
        return memberNames.has(name);
    }

    Json[string] debugInfo() {
        Json[string] info;
        return info
            .set("name", name)
            .set("classname", this.classname);
    }
}

class test : UIMObject {
    this() {
        super();
    }
    string newMethod() {
        return null; 
    }
    override string[] memberNames() {
        return [__traits(allMembers, typeof(this))];
    }
}
unittest {
    assert(new UIMObject);
    auto obj = new UIMObject;
    writeln("UIMObject -> ", obj.memberNames);
    writeln("new Object -> ", (new test).memberNames);
}
