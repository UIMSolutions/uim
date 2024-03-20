module uim.http.exceptions.missingcontroller;

import uim.http;

@safe:

// Exception used when a controller cannot be found.
class MissingControllerException : UimException {
 
    protected int _defaultCode = 404;

    protected string _messageTemplate = "Controller class `%s` could not be found.";
}
