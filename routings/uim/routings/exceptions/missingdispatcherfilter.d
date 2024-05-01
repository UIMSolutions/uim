module uim.routings.exceptions.missingdispatcherfilter;

import uim.routings;

@safe:

// Exception raised when a Dispatcher filter could not be found
class DMissingDispatcherFilterException : UimException {
    mixin(ExceptionThis!("MissingDispatcherFilter"));

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        this
            .messageTemplate("Dispatcher filter `%s` could not be found.");

        return true;
    }
}

mixin(ExceptionCalls!("MissingDispatcherFilter"));
