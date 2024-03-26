module uim.databases.classes.expressions.expression;

import uim.databases;

@safe:

class DDBExpression {
mixin TConfigurable!();

    this() {
        initialize;
    }

    this(IData[string] initData) {
        initialize(initData);
    }

    this(string name) {
        this();
        this.name(name);
    }

    // Hook method
    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        setConfigurationData(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));
}