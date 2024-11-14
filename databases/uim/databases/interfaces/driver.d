module uim.databases.interfaces.driver;

import uim.databases;

@safe:

interface IDriver {
    // Establishes a connection to the database server.
    IDriver connect();

    // String used to start a database identifier quoting to make it safe
    string startQuote();
    IDriver startQuote(string quote);

    // String used to end a database identifier quoting to make it safe
    string endQuote();
    IDriver endQuote(string quote);

    // Returns correct connection resource or object that is internally used.
    IConnection connection();

    // Set the internal connection object.
    IDriver connection(IConnection connection);

}
