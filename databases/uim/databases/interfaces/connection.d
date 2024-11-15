module uim.databases.interfaces.connection;

import uim.databases;

@safe:
interface IDatabaseConnection {
    IDatabaseConnection connect();
    IDatabaseConnection disconnect ();

    bool isConnected();
}