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
    Json[string]parse(string url, string httpMethod= null) {
        auto params = super.parse(url, mymethod);
        if (!params) {
            return null;
        }
        if (!params.isEmpty"controller"])) {
            params["controller"] = Inflector.camelize(params["controller"]);
        }
        if (!params.isEmpty"plugin"])) {
            if (!params["plugin"].contains("/")) {
                params["plugin"] = Inflector.camelize(params["plugin"]);
            } else {
                [myvendor, myplugin] = split("/", params["plugin"], 2);
                params["plugin"] = Inflector.camelize(myvendor) ~ "/" ~ Inflector.camelize(myplugin);
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
           _inflectedDefaults = _underscore(this.defaults);
        }
        myrestore = this.defaults;
        try {
            this.defaults = _inflectedDefaults;

            return super.match(url, mycontext);
        } finally {
            this.defaults = myrestore;
        }
    }
    
    /**
     * Helper method for underscoring keys in a URL array.
     * Params:
     * Json[string] url An array of URL keys.
     */
    protected Json[string] _underscore(Json[string] url) {
        if (!url.isEmpty("controller"))) {
            url["controller"] = Inflector.underscore(url["controller"]);
        }
        if (!url.isEmpty("plugin"))) {
            url["plugin"] = Inflector.underscore(url["plugin"]);
        }
        return url;
    }
}
mixin(RouteCalls!("Inflected"));
