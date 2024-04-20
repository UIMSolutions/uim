module uim.routings.exceptions.missingdispatcherfilter;

import uim.routings;

@safe:

// Exception raised when a Dispatcher filter could not be found
class DMissingDispatcherFilterException : UimException {
    mixin(ExceptionThis!("MissingDispatcherFilter"));

    protected string _messageTemplate = "Dispatcher filter `%s` could not be found.";
}
mixin(ExceptionCalls!("MissingDispatcherFilter"));
