module uim.logging.formatters.abstract_;

import uim.logging;

@safe:

abstract class DAbstractFormatter {
    mixin TConfigurable!();

    this() {
        initialize;
    }

    this(IData[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this().name(name);
    }

    // Hook method
    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.data(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));
    
    // Formats message.
    abstract string format(IData loggingLevel, string loggingMessage, IData[string] loggingData = null);
}
