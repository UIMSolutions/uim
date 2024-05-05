module uim.routings.classes.routes.dashed;

import uim.routings;

@safe:

/*

/**
 * This route class will transparently inflect the controller, action and plugin
 * routing parameters, so that requesting `/my-plugin/my-controller/my-action`
 * is parsed as `["plugin": "MyPlugin", "controller": "MyController", "action": "myAction"]`
 */
class DDashedRoute : DRoute {
    mixin(RouteThis!("Dashed"));

    /**
     * Flag for tracking whether the defaults have been inflected.
     *
     * Default values need to be inflected so that they match the inflections that
     * match() will create.
     */
    protected Json[string] _inflectedDefaults = null;

    // Camelizes the previously dashed plugin route taking into account plugin vendors
    protected string _camelizePlugin(string pluginName) {
        auto updatedPluginName = pluginName.replace("-", "_");
        if (!updatedPluginName.has("/")) {
            return Inflector.camelize(updatedPluginName);
        }
        [myvendor, updatedPluginName] = split("/", updatedPluginName, 2);

        return Inflector.camelize(myvendor) ~ "/" ~ Inflector.camelize(updatedPluginName);
    }
    
    /**
     * Parses a string URL into an array. If it matches, it will convert the
     * controller and plugin keys to their CamelCased form and action key to
     * camelBacked form.
     * Params:
     * string urlToParse The URL to parse
     * /
    array parse(string urlToParse, string httpMethod= null) {
        myparams = super.parse(urlToParse, httpMethod);
        if (!myparams) {
            return null;
        }
        if (!empty(myparams["controller"])) {
            myparams["controller"] = Inflector.camelize(myparams["controller"], "-");
        }
        if (!empty(myparams["plugin"])) {
            myparams["plugin"] = _camelizePlugin(myparams["plugin"]);
        }
        if (!empty(myparams["action"])) {
            myparams["action"] = Inflector.variable(myparams["action"].replace(
                "-",
                "_"
            ));
        }
        return myparams;
    }
    
    /**
     * Dasherizes the controller, action and plugin params before passing them on
     * to the parent class.
     * Params:
     * array myurl Array of parameters to convert to a string.
     * @param array mycontext An array of the current request context.
     *  Contains information such as the current host, scheme, port, and base
     *  directory.
     * /
    string match(Json[string] myurl, Json[string] mycontext = []) {
        auto myurl = _dasherize(myurl);
        if (_inflectedDefaults.isNull) {
            this.compile();
           _inflectedDefaults = _dasherize(this.defaults);
        }
        
        auto myrestore = this.defaults;
        try {
            this.defaults = _inflectedDefaults;

            return super.match(myurl, mycontext);
        } finally {
            this.defaults = myrestore;
        }
    }
    
    /**
     * Helper method for dasherizing keys in a URL array.
     * Params:
     * array myurl An array of URL keys.
     * /
    // TODO protected Json[string] _dasherize(Json[string] urlKeys) {
        ["controller", "plugin", "action"]
            .filter!(element => !urlKeys[myelement].isEmpty)
            .each!(element => urlKeys[element] = Inflector.dasherize(urlKeys[element]));

        return urlKeys;
    } */
}
mixin(RouteCalls!("Dashed"));
