module uim.http.classes.sessions.database;

import uim.http;

@safe:

/**
 * DatabaseSession provides methods to be used with Session.
 */
class DatabaseSession { // }: SessionHandler {
    mixin TLocatorAware;
    /* 

    // Reference to the table handling the session data
    protected ITable _table;

    // Number of seconds to mark the session as expired
    protected int _timeout;

    /**
     * Constructor. Looks at Session configuration information and
     * sets up the session model.
     * Params:
     * Json[string] configData The configuration for this engine. It requires the 'model'
     * key to be present corresponding to the Table to use for managing the sessions.
     * /
    this(Json[string] configData = null) {
        if (configData.hasKey("tableLocator")) {
            this.setTableLocator(configData("tableLocator"]);
        }
        aTableLocator = this.getTableLocator();

        if (configData.isEmpty("model")) {
            configData = aTableLocator.exists("Sessions") ? [] : ["table": "sessions", "allowFallbackClass": true.toJson];
           _table = aTableLocator.get("Sessions", configData);
        } else {
           _table = aTableLocator.get(configData("model"]);
        }
       _timeout = to!int(ini_get("session.gc_maxlifetime"));
    }
    
    /**
     * Set the timeout value for sessions.
     *
     * Primarily used in testing.
     * /
    void setTimeout(int timeoutDuration) {
       _timeout = timeoutDuration;
    }
    
    /**
     * Method called on open of a database session.
     * Params:
     * string aPath The path where to store/retrieve the session.
     * /
    bool open(string aPath, string sessionName) {
        return true;
    }
    
    /**
     * Method called on close of a database session.
     *
         * /
    bool close() {
        return true;
    }
    
    /**
     * Method used to read from a database session.
     * Params:
     * string aid ID that uniquely identifies session in database.
     * /
    string read(string aid) {
        string[] primaryKeys = _table.primaryKeys();
        assert(isString(primaryKeys));
        result = _table
            .find("all")
            .select(["data"])
            .where([primaryKeys:  anId])
            .disableHydration()
            .first();

        if (result.isEmpty) {
            return "";
        }
        if (isString(result["data"])) {
            return result["data"];
        }
        
        string result = stream_get_contents(result["data"]);
        return result
            ? result
            : null;
    }
    
    /**
     * Helper auto called on write for database sessions.
     * Params:
     * string aid ID that uniquely identifies session in database.
     * @param string adata The data to be saved.
     * /
    bool write(string aid, string adata) {
        string[] primaryKeys = _table.primaryKeys();
        session = _table.newEntity([
            primaryKeys:  anId,
            "data": someData,
            "expires": time() + _timeout,
        ], ["accessibleFields": [primaryKeys: true]]);

        return (bool)_table.save(session);
    }
    
    /**
     * Method called on the destruction of a database session.
     * Params:
     * string aid ID that uniquely identifies session in database.
     * /
    bool destroy(string aid) {
        /** @var string apk) {  _table.deleteAll([primaryKeys:  anId]);

        return true;) {

    /**
     * Helper auto called on gc for database sessions.
     * Params:
     * int maxlifetime Sessions that have not updated for the last maxlifetime seconds will be removed.
     * /
    int gc(int maxlifetime) {
        return _table.deleteAll(["expires <": time()]);
    } */
}
