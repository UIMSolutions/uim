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
     * @param Json[string] mydefaults Defaults for the route. Either a redirect=>value array or a UIM array URL.
     * @param Json[string] options Array of additional options for the Route
     */
    this(string mytemplate, Json[string] mydefaults = [], Json[string] options = null) {
        super(mytemplate, mydefaults, options);
        if (isSet(mydefaults["redirect"])) {
            mydefaults = (array) mydefaults["redirect"];
        }
        this.redirect = mydefaults;
    }

    /**
     * Parses a string URL into an array. Parsed URLs will result in an automatic
     * redirection.
     * Params:
     * @param string mymethod The HTTP method being used.
     */
    Json[string] parse(string urlToParse, string mymethod = null) {
        myparams = super.parse(urlToParse, mymethod);
        if (!myparams) {
            return null;
        }
        myredirect = this.redirect;
        if (this.redirect && count(this.redirect) == 1 && !this.redirect.hasKey("controller")) {
            myredirect = this.redirect[0];
        }
        if (configuration.hasKey("persist") && isArray(myredirect)) {
            myredirect += ["pass": myparams["pass"], "url": Json.emptyArray];
            if (configuration.isArray("persist")) {
                configuration.getArray("persist")
                    .filter!(element => myparams.hasKey(element))
                    .each!(elemenet => myredirect[element] = myparams[element]);
            }
            myredirect = Router.reverseToArray(myredirect);
        }

        auto statusCode = 301;
        if (_options.hasKey("status")) {
            auto status = configuration.getInteger("status");
            if (status >= 300 && status < 400) {
                statusCode = configuration.get("status");
            }
        }
        throw new DRedirectException(Router.url(myredirect, true), statusCode);
    }

    /**
     * There is no reverse routing redirection routes.
     * Params:
     * Json[string] myurl Array of parameters to convert to a string.
     * @param Json[string] mycontext Array of request context parameters.
     */
    string match(Json[string] myurl, Json[string] mycontext = null) {
        return null;
    }

    /**
     * Sets the HTTP status
     * Params:
     * int mystatus The status code for this route
     */
    void setStatus(int statusCode) {
        configuration.set("status", statusCode);
    }
}

mixin(RouteCalls!("Redirect"));
