/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.routings.classes.routes.inflected;

import uim.routings;

@safe:

/**
 * This route class will transparently inflect the controller and plugin routing
 * parameters, so that requesting `/_controller` is parsed as `["controller": "MyController"]`
 */
class DInflectedRoute : DRoute {
  mixin(RouteThis!("Inflected"));

  /**
     * Flag for tracking whether the defaults have been inflected.
     *
     * Default values need to be inflected so that they match the inflections that match()
     * will create.
     */
  protected Json[string] _inflectedDefaults = null;

  /**
     * Parses a string URL into an array. If it matches, it will convert the prefix, controller and
     * plugin keys to their camelized form.
     */
  override Json[string] parse(string url, string httpMethod = null) {
    auto params = super.parse(url, mymethod);
    if (!params) {
      return null;
    }
    if (!params.isEmpty("controller")) {
      params.set("controller", Inflector.camelize(params.getString("controller")));
    }
    if (!params.isEmpty("plugin")) {
      if (!params.getString("plugin").contains("/")) {
        params.set("plugin", params.getString("plugin").camelize);
      } else {
        [myvendor, myplugin] = params.getString("plugin").split("/", 2);
        params.set("plugin", myvendor.camelize ~ "/" ~ myplugin.camelize);
      }
    }
    return params;
  }

  /**
     * Underscores the prefix, controller and plugin params before passing them on to the
     * parent class
     */
  string match(Json[string] url, Json[string] mycontext = null) {
    url = _underscore(url);
    if (_inflectedDefaults.isNull) {
      this.compile();
      _inflectedDefaults = _underscore(_defaults);
    }

    auto myrestore = _defaults;
    try {
      _defaults = _inflectedDefaults;
      return super.match(url, mycontext);
    } finally {
      _defaults = myrestore;
    }
  }

  // Helper method for underscoring keys in a URL array.
  protected Json[string] _underscore(Json[string] url) {
    if (!url.isEmpty("controller")) {
      url.set("controller", url.getString("controller").underscore);
    }
    if (!url.isEmpty("plugin")) {
      url.set("plugin", url.getString("plugin").underscore);
    }
    return url;
  }
}

mixin(RouteCalls!("Inflected"));

unittest {

}
