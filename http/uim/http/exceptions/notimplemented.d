module uim.http.exceptions.notimplemented;

import uim.http;

@safe:

// Not Implemented Exception - used when an API method is not implemented
class DNotImplementedException : DHttpException {
 
    protected string _messageTemplate = "%s is not implemented.";
 
    protected int _defaultCode = 501;
}
