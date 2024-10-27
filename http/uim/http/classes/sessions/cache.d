/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.sessions.cache;

import uim.http;

@safe:

// CacheSession provides method for saving sessions into a Cache engine. Used with Session
class DCacheSession : DSession { // }: !SessionHandler {
    mixin(SessionThis!("Cache"));
    
    // Method called on open of a database session.
    bool open(string sessionPath, string sessionName) {
        return true;
    }
    
    // Method called on close of a database session.
    override bool close() {
        return true;
    }
    
    // Method used to read from a cache session.
    string read(string sessionId) {
        // return Cache.read(sessionId, _options.getString("config", ""));
        return null; 
    }
    
    // Helper auto called on write for cache sessions.
    bool write(string sessionId, string dataToSave) {
        /* return sessionId
            ? Cache.write(sessionId, dataToSave, _options.get("config"))
            : false; */
            return false;
    }
    
    // Method called on the destruction of a cache session.
    bool destroy(string id) {
        // TODO Cache.removeKey(id, _options.get("config"));

        return true;
    }
    
    //No-op method. Always returns 0 since cache engine don`t have garbage collection.
    int gc(int maxlifetime) {
        return 0;
    }
}
