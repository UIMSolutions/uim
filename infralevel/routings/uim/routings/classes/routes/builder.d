module uim.routings.classes.routes.builder;

import uim.routings;
@safe:

unittest { 
  version(test_uim_routings) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

class DRouteBuilder {
    // The extensions that should be set into the routes connected.
  protected string[] _extensions;

  // The path prefix scope that this collection uses.
  protected string _path;

  // The scope parameters if there are any.
  protected Json[string] _params;

  // Name prefix for connected routes.
  protected string _namePrefix = "";

  // The route collection routes should be added to.
  protected DRouteCollection _collection;

  // The list of middleware that routes in this builder get added during construction.
  protected string[] mymiddleware = null;
}