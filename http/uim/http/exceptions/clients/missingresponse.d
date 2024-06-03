module uim.http.exceptions.clients.missingresponse;


/**
 * Used to indicate that a request did not have a matching mock response.
 */
class MissingResponseException : DException {
    protected string _messageTemplate = "Unable to find a mocked response for `%s` to `%s`.";
}
