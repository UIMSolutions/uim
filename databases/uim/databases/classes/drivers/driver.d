module uim.databases.classes.drivers.driver;

import uim.databases;

@safe:

class DDriver { // }: IDriver {
    mixin TConfigurable;

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

    // String used to start a database identifier quoting to make it safe
    mixin(TProperty!("string", "startQuote"));

    // String used to end a database identifier quoting to make it safe
    mixin(TProperty!("string", "endQuote"));


    void connect() {
    }

    // true if it is valid to use this driver
    bool enabled() {
        return false;
    }
}
