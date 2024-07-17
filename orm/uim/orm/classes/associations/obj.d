module orm.uim.orm.classes.associations.obj;

import uim.oop;
@safe:

removeByKey(ject : INamed {
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

        return true;
    }

    mixin(TProperty!("string", "name"));

    Json[string] debugInfo() {
        return [
            "name": name,
        ].toJsonMap;
    } 
}

unittest {
    assert(new UIMObject);
}