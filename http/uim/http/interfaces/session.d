module uim.http.interfaces.session;

import uim.http;

@safe:

interface ISession {
  // Unique session id of this session.
  string id();

  // Queries the session for the existence of a particular key.
  bool hasKey(string key);

  // Gets a typed field from the session.
  Json get(string key, Json defaultValue = Json(null));

  // Checks if the session is active.
  bool opCast();
  
  // Enables foreach - iteration over all keys of the session.
  // TODO opApply(del) 

  // Sets a typed field to the session.
  void set(string key, string value);
  void set(string key, int value);
  void set(string key, Json value);

  string getLong(string key);

  string getString(string key);

  void removeKeys(string[] keys);

  void removeKey(string key);
}
