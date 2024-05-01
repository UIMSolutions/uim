module uim.routings.exceptions.missingroute;

import uim.routings;

@safe: 

// Exception raised when a URL cannot be reverse routed or when a URL cannot be parsed.
class DMissingRouteException : UimException {
    mixin(ExceptionThis!("MissingRoute"));
 
   override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this
      .messageTemplate("A route matching `%s` could not be found.");

    return true;
  }


    /**
     * Message template to use when the requested method is included.
     */
    protected string _messageTemplateWithMethod = "A `%s` route matching `%s` could not be found.";

    /**
     * Constructor.
     * Params:
     * Json[string]|string amessage Either the string of the error message, or an array of attributes
     *  that are made available in the view, and sprintf()"d into Exception._messageTemplate
     * @param int code The code of the error, is also the HTTP status code for the error. Defaults to 404.
     * @param \Throwable|null previous the previous exception.
     * /
    this(string[] amessage, int code = 404, Throwable previousException = null) {
        if (message.isArray) {
            if (isSet(message["message"])) {
               _messageTemplate = message["message"];
            } else if (isSet(message["method"]) && message["method"]) {
               _messageTemplate = _messageTemplateWithMethod;
            }
        }
        super(message, code, previous);
    } 
    */
}
mixin(ExceptionCalls!("MissingRoute"));
