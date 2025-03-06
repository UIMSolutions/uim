module uim.routings.classes.routes.pluginshort;

import uim.routings;
@safe:

unittest { 
  version(test_uim_routings) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

/*
/**
 * Plugin short route, that copies the plugin param to the controller parameters
 * It is used for supporting /{plugin} routes.
 */
class DPluginShortRoute : DInflectedRoute {
    mixin(RouteThis!("PluginShort"));
}

mixin(RouteCalls!("PluginShort"));

unittest {
    assert(testRoute(new DPluginShortRoute));
}
