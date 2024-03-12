module uim.databases.classes.drivers.driver;

import uim.databases;

@safe:

class DDriver { // }: IDriver {
    mixin TConfigurable!(); 
    // Hook method
    bool initialize(IData[string] initData = null) {
        configuration(MemoryConfiguration);
        configuration.update(initData);

        return true;
    }

    // String used to start a database identifier quoting to make it safe
    mixin(TProperty!("string", "startQuote"));

    // String used to end a database identifier quoting to make it safe
    mixin(TProperty!("string", "endQuote"));

    mixin(TProperty!("string", "name"));

    void connect() {
    }

    /**
     * Returns whether D is able to use this driver for connecting to database
     * returns true if it is valid to use this driver
     */
    bool enabled() {
        return false;
    }
}
