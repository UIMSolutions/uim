module uim.routings.exceptions.missingdispatcherfilter;

import uim.routings;

@safe:

// Exception raised when a Dispatcher filter could not be found
class MissingDispatcherFilterException : UimException {
    protected string _messageTemplate = "Dispatcher filter `%s` could not be found.";
}
