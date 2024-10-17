/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.routings.classes.routes.redirect;

import uim.routings;

@safe:
/**
 * Redirect route will perform an immediate redirect. Redirect routes
 * are useful when you want to have Routing layer redirects occur in your
 * application, for when URLs move.
 *
 * Redirection is signalled by an exception that halts route matching and
 * defines the redirect URL and status code.
 */
class DRedirectRoute : DRoute {
    mixin(RouteThis!("Redirect"));
    /* 
    // The location to redirect to.
    Json[string]myredirect;

    /**
     
     * Params:
     * string mytemplate Template string with parameter placeholders
     */
    this(string templateText, Json[string] defaults = [], Json[string] options = null) {
        super(templateText, defaults, options);
        if (defaults.hasKey("redirect")) {
            /* mydefaults = (array) mydefaults["redirect"]; */
        }
        /* _redirect = mydefaults; */
    }

    // Parses a string URL into an array. Parsed URLs will result in an automatic redirection.
    Json[string] parse(string urlToParse, string httpMethod = null) {
        auto params = super.parse(urlToParse, httpMethod);
        if (!params) {
            return null;
        }
        
        auto myredirect = _redirect;
        if (_redirect && count(_redirect) == 1 && !_redirect.hasKey("controller")) {
            myredirect = _redirect[0];
        }
        if (configuration.hasKey("persist") && isArray(myredirect)) {
            myredirect += ["pass": params["pass"], "url": Json.emptyArray];
            if (configuration.isArray("persist")) {
                configuration.get("persist").toArray
                    .filter!(element => params.hasKey(element))
                    .each!(elemenet => myredirect[element] = params[element]);
            }
            myredirect = Router.reverseToArray(myredirect);
        }

        auto statusCode = 301;
        if (configuration.hasKey("status")) {
            auto status = configuration.getInteger("status");
            if (status >= 300 && status < 400) {
                statusCode = status;
            }
        }
        throw new DRedirectException(Router.url(myredirect, true), statusCode);
    }

    // There is no reverse routing redirection routes.
    string match(Json[string] urlParameters, Json[string] contextParameters = null) {
        return null;
    }

    // Sets the HTTP status
    void setStatus(int statusCode) {
        configuration.set("status", statusCode);
    }
}

mixin(RouteCalls!("Redirect"));
