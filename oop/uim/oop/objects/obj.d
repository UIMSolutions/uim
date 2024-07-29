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

        _methodNames = [ __traits(allMembers, UIMObject) ];
        return true;
    }

    mixin(TProperty!("string", "name"));
    mixin(TProperty!("string[]", "methodNames"));
    bool hasMethod(string name) {
        return _methodNames.has(name);
    }

    Json[string] debugInfo() {
        Json[string] info; 
        info.set("name", name);
        return info;
    } 
}

unittest {
    assert(new UIMObject);
}