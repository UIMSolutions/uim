module uim.views.classes.contexts.context;

import uim.views;

@safe:

class DContext {
    mixin TConfigurable; 

    this() {
        initialize; this.name("DContext");
    }
    this(IData[string] initData) {
        this().initialize(initData);
    }
    this(string name) {
        this().name(name);
    }

    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));

    const string[] VALID_ATTRIBUTES = [
        "length", "precision", "comment", "null", "default"
    ];

    // Get the field names of the top level object in this context.
    string[] fieldNames() {
        return null;
    }
}
