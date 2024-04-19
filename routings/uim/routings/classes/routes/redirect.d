module source.uim.myname.classes.routes.redirect;

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
class DRedirectRoute : Route {
    /* 
    // The location to redirect to.
    array myredirect;

    /**
     * Constructor
     * Params:
     * string mytemplate Template string with parameter placeholders
     * @param array mydefaults Defaults for the route. Either a redirect=>value array or a UIM array URL.
     * @param IData[string] options Array of additional options for the Route
     * /
    this(string mytemplate, array mydefaults = [], IData[string] optionData = null) {
        super(mytemplate, mydefaults, options);
        if (isSet(mydefaults["redirect"])) {
            mydefaults = (array)mydefaults["redirect"];
        }
        this.redirect = mydefaults;
    }
    
    /**
     * Parses a string URL into an array. Parsed URLs will result in an automatic
     * redirection.
     * Params:
     * @param string mymethod The HTTP method being used.
     * /
    array parse(string urlToParse, string mymethod= null) {
        myparams = super.parse(urlToParse, mymethod);
        if (!myparams) {
            return null;
        }
        myredirect = this.redirect;
        if (this.redirect && count(this.redirect) == 1 && !this.redirect.isSet("controller")) {
            myredirect = this.redirect[0];
        }
        if (isSet(configuration.update("persist"]) && isArray(myredirect)) {
            myredirect += ["pass": myparams["pass"], "url": ArrayData];
            if (configuration.update("persist"].isArray) {
                fconfiguration.update("persist"]
                    .filter!(element => isSet(myparams[element]))
                    .each!(elemenet => myredirect[element] = myparams[element]);
            }
            myredirect = Router.reverseToArray(myredirect);
        }
        
        auto statusCode = 301;
        if (this.options.isSet("status") && (configuration.update("status"] >= 300 && configuration.update("status"] < 400)) {
            statusCode = configuration.update("status"];
        }
        throw new DRedirectException(Router.url(myredirect, true), statusCode);
    }
    
    /**
     * There is no reverse routing redirection routes.
     * Params:
     * array myurl Array of parameters to convert to a string.
     * @param array mycontext Array of request context parameters.
     * /
    string match(array myurl, array mycontext = []) {
        return null;
    }
    
    /**
     * Sets the HTTP status
     * Params:
     * int mystatus The status code for this route
     * /
    void setStatus(int mystatus) {
        configuration.update("status"] = mystatus;
    }
    */
}
