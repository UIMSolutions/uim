module uim.databases.classes.drivers.driver;

import uim.databases;

@safe:

class DDriver : UIMObject, IDriver {
    mixin(DriverThis!());

    // Establishes a connection to the database server.
    IDriver connect() {
        return this;
    }

    // String used to start a database identifier quoting to make it safe
    string startQuote() {
        return null; 
    }

    IDriver startQuote(string quote) {
        return this;
    }

    // String used to end a database identifier quoting to make it safe
    string endQuote() {
        return null; 
    }

    IDriver endQuote(string quote) {
        return this;
    }

    // Returns correct connection resource or object that is internally used.
    IConnection connection() {
        return null; 
    }

    // Set the internal connection object.
    IDriver connection(IConnection connection) {
        return this;
    }
}