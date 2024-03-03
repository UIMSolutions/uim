module uim.views.classes.contexts.context;

import uim.views;

@safe:

class DContext {
    bool initialize(IData[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        configuration(new DConfiguration);
        configuration.update(initData);

        return true;
    }

    const string[] VALID_ATTRIBUTES = [
        "length", "precision", "comment", "null", "default"
    ];
}
