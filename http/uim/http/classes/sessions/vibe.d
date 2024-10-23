/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.http.classes.sessions.vibe;

import uim.http;

@safe:

// Represents a single HTTP session using vibe
class DVibeSession : DHttpSession {
  mixin(SessionThis!("Vibe"));

  protected vibe.http.session.Session = _SESSION;
  void session(vibe.http.session.Session session) {
    _session = session;
  }

  override id() {
    return _session.id;
  }

  override bool hasKey(string key) {
    return _session.isKeySet(key);
  }

  override string getString(string key) {
    return get!string(key);
  }
}

mixin(SessionCalls!("Vibe"));
