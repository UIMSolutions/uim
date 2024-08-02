module uim.views.classes.contexts.context;

import uim.views;

@safe:

class DContext : UIMObject, IContext {
    mixin(ContextThis!(""));

    override bool initialize(Json[string] initData = null) {
        if (super.initialize(initData)) {
            return false;
        }
        
        return true;
    }

    const string[] VALID_ATTRIBUTES = [
        "length", "precision", "comment", "null", "default"
    ];

    // Get the field names of the top level object in this context.
    string[] fieldNames() {
        return null;
    }

    Json[string] data() {
        // TODO 
        return null;
    }

    size_t maxLength(string fieldName) {
        // TODO 
        return 0;
    }

}
