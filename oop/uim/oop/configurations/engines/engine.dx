module uim.oop.configurations.engines.engine;

import uim.oop;

@safe:

class DConfigEngine : IConfigEngine {
    mixin TConfigurable; 

    this() {
        initialize; this.name(this.className);
    }
    this(Json[string] initData) {
        this().initialize(initData);
    }
    this(string name) {
        this().name(name);
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));
}