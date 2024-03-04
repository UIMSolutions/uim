module uim.databases.interfaces.driver;

import uim.databases;

@safe:

interface IDriver : INamed {
    void connect();

    // String used to start a database identifier quoting to make it safe
    mixin(IProperty!("string", "startQuote"));

    // String used to end a database identifier quoting to make it safe
    mixin(IProperty!("string", "endQuote"));
}