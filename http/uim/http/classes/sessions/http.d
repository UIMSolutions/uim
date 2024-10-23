/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module http.uim.http.classes.sessions.http;

import uim.http;

@safe:

// Represents a single HTTP session.
class DHttpSession : DSession {
  mixin(SessionThis!("Http"));
}

mixin(SessionCalls!("Http"));
