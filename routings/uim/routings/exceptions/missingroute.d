module uim.routings.exceptions.missingroute;

import uim.routings;

@safe: 

// Exception raised when a URL cannot be reverse routed or when a URL cannot be parsed.
class DMissingRouteException : DException {
    mixin(ExceptionThis!("MissingRoute"));
 
   override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("A route matching `%s` could not be found.");

    return true;
  }


    // Message template to use when the requested method is included.
    protected string _messageTemplateWithMethod = "A `%s` route matching `%s` could not be found.";

    /**
     .
     * Params:
     * Json[string]|string errorMessages Either the string of the error message, or an array of attributes
     * that are made available in the view, and sprintf()"d into Exception._messageTemplate
     */
    this(string[] errorMessages, int errorCode = 404, Throwable previousException = null) {
        if (errorMessages.isArray) {
            if (errorMessages.hasKey("errorMessages")) {
               _messageTemplate = errorMessages["message"];
            } else if (errorMessages.hasKey("method") && errorMessages["method"]) {
               _messageTemplate = _messageTemplateWithMethod;
            }
        }
        super(errorMessages, errorCode, previousException));
    } 
}
mixin(ExceptionCalls!("MissingRoute"));
