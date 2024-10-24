/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.sessions.database;

import uim.http;

@safe:

// DatabaseSession provides methods to be used with Session.
class DDatabaseSession : DSession { // }: SessionHandler {
  mixin(SessionThis("Database"));
  // TODO mixin TLocatorAware;

  // Reference to the table handling the session data
  protected ITable _table;

  // Number of seconds to mark the session as expired
  protected int _timeout;

  // Looks at Session configuration information and sets up the session model.
  this(Json[string] configData = null) {
    if (configData.hasKey("tableLocator")) {
      setTableLocator(configuration.get("tableLocator"));
    }
    aTableLocator = getTableLocator();

    if (configData.isEmpty("model")) {
      configData = aTableLocator.hasKey("Sessions")
        ? createMap!(string, Json) : createMap!(string, Json)
        .set("table", "sessions")
        .set("allowFallbackClass", true);

      _table = aTableLocator.get("Sessions", configData);
    } else {
      _table = aTableLocator.get(configuration.getString("model"));
    }
    _timeout = to!int(ini_get("session.gc_maxlifetime"));
  }

  /**
     * Set the timeout value for sessions.
     *
     * Primarily used in testing.
     */
  void setTimeout(int timeoutDuration) {
    _timeout = timeoutDuration;
  }

  /**
     * Method called on open of a database session.
     * Params:
     * string aPath The path where to store/retrieve the session.
     */
  bool open(string aPath, string sessionName) {
    return true;
  }

  // Method called on close of a database session.
  bool close() {
    return true;
  }

  // Method used to read from a database session.
  string read(string aId) {
    string[] primaryKeys = _table.primaryKeys();
    assert(isString(primaryKeys));
    result = _table
      .find("all")
      .select(["data"])
      .where([primaryKeys: anId])
      .disableHydration()
      .first();

    if (result.isEmpty) {
      return null;
    }

    if (result.isString("data")) {
      return result.getString("data");
    }

    string result = stream_get_contents(result["data"]);
    return result
      ? result : null;
  }

  // Helper auto called on write for database sessions.
  bool write(string sessionId, string dataToSave) {
    string[] primaryKeys = _table.primaryKeys();
    auto session = _table.newEntity([
      primaryKeys: sessionId,
      "data": dataToSave,
      "expires": time() + _timeout,
    ], ["accessibleFields": [primaryKeys: true]]);

    return  /* (bool) */ _table.save(session);
  }

  // Method called on the destruction of a database session.
  bool destroy(string id) {
    _table.deleteAll([primaryKeys: id]);

    return true;
  }

  // Helper auto called on gc for database sessions.
  int gc(int maxlifetime) {
    return _table.deleteAll(["expires <": time()]);
  }
}

mixin(SessionCalls("Database"));
