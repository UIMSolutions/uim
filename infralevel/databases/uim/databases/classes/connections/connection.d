module uim.databases.classes.connections.connection;

import uim.databases;

@safe:

class DDatabaseConnection : UIMObject, IDatabaseConnection {
    IDatabaseConnection connect() {
        return this;
    }

    IDatabaseConnection disconnect () {
        return this;
    }

    bool isConnected() {
        return false;
    }
}