module uim.routings.exceptions.duplicatenamedroute;

import uim.routings;

@safe:

// Exception raised when a route names used twice.
class DDuplicateNamedRouteException : DException {
    mixin(ExceptionThis!("DuplicateNamedRoute"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        this
            .messageTemplate("A route named `%s` has already been connected to `%s`.");

        return true;
    }

    /**
     .
     * Params:
     * Json[string]|string amessage Either the string of the error message, or an array of attributes
     * that are made available in the view, and sprintf()"d into Exception._messageTemplate
     */
    this(string[] amessage, int errorCode = 404, Throwable previousException = null) {
        if (message.isArray && message.hasKey("message")) {
           _messageTemplate = message["message"];
        }
        super(message, errorCode, previousException));
    }
}

mixin(ExceptionCalls!("DuplicateNamedRoute"));
