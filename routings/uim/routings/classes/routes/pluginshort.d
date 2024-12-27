module uim.routings.classes.routes.pluginshort;

import uim.routings;

@safe:

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
