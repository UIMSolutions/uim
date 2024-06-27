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

    this(string newName) {
        this().name(newName);
    }

    this(string newName, Json[string] initData) {
        this(initData).name(newName);
    }

    bool initialize(Json[string] initData = null) {
        name("Attribute");

        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));
}

unittest {
    assert(new UIMObject);
}