module uim.routings.exceptions.duplicatenamedroute;

import uim.routings;

@safe:

// Exception raised when a route names used twice.
class DuplicateNamedRouteException : UimException {
 
    protected string _messageTemplate = "A route named `%s` has already been connected to `%s`.";

    /**
     * Constructor.
     * Params:
     * IData[string]|string amessage Either the string of the error message, or an array of attributes
     *  that are made available in the view, and sprintf()"d into Exception._messageTemplate
     * @param int code The code of the error, is also the HTTP status code for the error. Defaults to 404.
     * @param \Throwable|null previous the previous exception.
     * /
    this(string[] amessage, int code = 404, Throwable previousException = null) {
        if (isArray(message) && isSet(message["message"])) {
           _messageTemplate = message["message"];
        }
        super(message, code, previous);
    }
    */
}
