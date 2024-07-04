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
        auto myparams = super.parse(url, httpMethod);
        if (!myparams) {
            return null;
        }
        myparams["controller"] = myparams["plugin"];
        return myparams;
    }
    
    /**
     * Reverses route plugin shortcut URLs. If the plugin and controller
     * are not the same the match is an auto fail.
     * Params:
     * Json[string] url Array of parameters to convert to a string.
     * @param Json[string] mycontext An array of the current request context.
     * Contains information such as the current host, scheme, port, and base
     * directory.
     */
    string match(Json[string] url, Json[string] mycontext= null) {
        if (isSet(url["controller"], url["plugin"]) && url["plugin"] != url["controller"]) {
            return null;
        }
        this.defaults["controller"] = url["controller"];
        result = super.match(url, mycontext);
        remove(this.defaults["controller"]);

        return result;
    }
}
mixin(RouteCalls!("PluginShort"));
