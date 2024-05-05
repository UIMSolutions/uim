module uim.i18n.classes.parsers.momessage;

import uim.i18n;

@safe:
// Message in PO format
class DMoMessage {
    mixin TConfigurable;

    this() {
        initialize;
    }

    bool initialize(Json[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);
        
        return true;
    }
}