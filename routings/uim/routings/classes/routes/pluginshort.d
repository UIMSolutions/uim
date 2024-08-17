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

    /**
     * Parses a string URL into an array. If a plugin key is found, it will be copied to the
     * controller parameter.
     */
    auto parse(string url, string httpMethod= null) {
        auto params = super.parse(url, httpMethod);
        if (!params) {
            return null;
        }
        params.set("controller", params["plugin"]);
        return params;
    }
    
    /**
     * Reverses route plugin shortcut URLs. If the plugin and controller
     * are not the same the match is an auto fail.
     */
    string match(Json[string] url, Json[string] context = null) {
        if (isSet(url.get("controller"), url.get("plugin")) && url.get("plugin") != url.get("controller")) {
            return null;
        }
        _defaults.set("controller", url.get("controller"));
        result = super.match(url, context);
        _defaults.removeKey("controller");

        return result;
    }
}
mixin(RouteCalls!("PluginShort"));
