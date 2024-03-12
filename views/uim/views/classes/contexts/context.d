module uim.views.classes.contexts.context;

import uim.views;

@safe:

class DContext {
    bool initialize(IData[string] initData = null) {
        // configuration(MemoryConfiguration);
        // configurationData(initData);

        return true;
    }

    const string[] VALID_ATTRIBUTES = [
        "length", "precision", "comment", "null", "default"
    ];
}
