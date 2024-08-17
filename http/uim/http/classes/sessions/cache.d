module uim.http.classes.sessions.cache;

import uim.http;

@safe:

/**use InvalidArgumentException;
use !SessionHandler;
/**
 * CacheSession provides method for saving sessions into a Cache engine. Used with Session
 */
class DCacheSession { // }: !SessionHandler {
    // Options for this session engine
    protected Json[string] _options = null;

    /**
     .
     * Params:
     * Json[string] configData The configuration to use for this engine
     * It requires the key 'config' which is the name of the Cache config to use for
     * storing the session
     */
    this(Json[string] initData = null) {
        if (configData.isEmpty("config")) {
            throw new DInvalidArgumentException("The cache configuration name to use is required");
        }
       _options = configData;
    }
    
    // Method called on open of a database session.
    bool open(string sessionPath, string sessionName) {
        return true;
    }
    
    // Method called on close of a database session.
    bool close() {
        return true;
    }
    
    // Method used to read from a cache session.
    string read(string sessionId) {
        return Cache.read(sessionId, _options.getString("config", ""));
    }
    
    // Helper auto called on write for cache sessions.
    bool write(string sessionId, string dataToSave) {
        return sessionId
            ? Cache.write(sessionId, dataToSave, _options.get("config"))
            : false;
    }
    
    /**
     * Method called on the destruction of a cache session.
     * Params:
     * string aid ID that uniquely identifies session in cache.
     */
    bool destroy(string aid) {
        Cache.removeKey(anId, _options.get("config"));

        return true;
    }
    
    /**
     * No-op method. Always returns 0 since cache engine don`t have garbage collection.
     * Params:
     * int maxlifetime Sessions that have not updated for the last maxlifetime seconds will be removed.
     */
    int gc(int maxlifetime) {
        return 0;
    }
}
