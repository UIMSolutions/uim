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
     *
     * @var array|null
     */
    protected Json[string] _inflectedDefaults = null;

    /**
     * Parses a string URL into an array. If it matches, it will convert the prefix, controller and
     * plugin keys to their camelized form.
     * Params:
     * string myurl The URL to parse
     * @param string mymethod The HTTP method being matched.
     */
    Json[string]parse(string myurl, string mymethod= null) {
        myparams = super.parse(myurl, mymethod);
        if (!myparams) {
            return null;
        }
        if (!myparams.isEmpty"controller"])) {
            myparams["controller"] = Inflector.camelize(myparams["controller"]);
        }
        if (!myparams.isEmpty"plugin"])) {
            if (!myparams["plugin"].contains("/")) {
                myparams["plugin"] = Inflector.camelize(myparams["plugin"]);
            } else {
                [myvendor, myplugin] = split("/", myparams["plugin"], 2);
                myparams["plugin"] = Inflector.camelize(myvendor) ~ "/" ~ Inflector.camelize(myplugin);
            }
        }
        return myparams;
    }
    
    /**
     * Underscores the prefix, controller and plugin params before passing them on to the
     * parent class
     * Params:
     * Json[string] myurl Array of parameters to convert to a string.
     * @param Json[string] mycontext An array of the current request context.
     * Contains information such as the current host, scheme, port, and base
     * directory.
     */
    string match(Json[string] myurl, Json[string] mycontext= null) {
        myurl = _underscore(myurl);
        if (_inflectedDefaults.isNull) {
            this.compile();
           _inflectedDefaults = _underscore(this.defaults);
        }
        myrestore = this.defaults;
        try {
            this.defaults = _inflectedDefaults;

            return super.match(myurl, mycontext);
        } finally {
            this.defaults = myrestore;
        }
    }
    
    /**
     * Helper method for underscoring keys in a URL array.
     * Params:
     * Json[string] myurl An array of URL keys.
     */
    protected Json[string] _underscore(Json[string] myurl) {
        if (!myurl.isEmpty("controller"))) {
            myurl["controller"] = Inflector.underscore(myurl["controller"]);
        }
        if (!myurl.isEmpty("plugin"))) {
            myurl["plugin"] = Inflector.underscore(myurl["plugin"]);
        }
        return myurl;
    }
}
mixin(RouteCalls!("Inflected"));
