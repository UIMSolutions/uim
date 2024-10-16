/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
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
        if (!updatedPluginName.contains("/")) {
            return updatedPluginName.camelize;
        }
        [myvendor, updatedPluginName] = split("/", updatedPluginName, 2);

        return myvendor.camelize ~ "/" ~ updatedPluginName.camelize;
    }

    /**
     * Parses a string URL into an array. If it matches, it will convert the
     * controller and plugin keys to their CamelCased form and action key to
     * camelBacked form.
     */
    override Json[string] parse(string urlToParse, string httpMethod = null) {
        params = super.parse(urlToParse, httpMethod);
        if (!params) {
            return null;
        }
        if (!params.isEmpty("controller")) {
            params.set("controller", params["controller"].camelize("-"));
        }
        if (!params.isEmpty("plugin")) {
            params.set("plugin", _camelizePlugin(params["plugin"]));
        }
        if (!params.isEmpty("action")) {
            params.set("action", Inflector.variable(params["action"].replace(
                    "-",
                    "_"
                )));
        }
        return params;
    }

    /**
     * Dasherizes the controller, action and plugin params before passing them on
     * to the parent class.
     */
    override string match(Json[string] url, Json[string] context = null) {
        auto url = _dasherize(url);
        if (_inflectedDefaults.isNull) {
            this.compile();
            _inflectedDefaults = _dasherize(this.defaults);
        }

        auto myrestore = this.defaults;
        try {
            this.defaults = _inflectedDefaults;

            return super.match(url, context);
        } finally {
            this.defaults = myrestore;
        }
    }

    // Helper method for dasherizing keys in a URL array.
    protected Json[string] _dasherize(Json[string] urlKeys) {
        ["controller", "plugin", "action"]
            .filter!(element => !urlKeys.isEmpty(myelement))
            .each!(element => urlKeys[element] = Inflector.dasherize(urlKeys[element]));

        return urlKeys;
    }
}

mixin(RouteCalls!("Dashed"));
