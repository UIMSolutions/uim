module uim.events.classes.decorators.subjectfilter;

import uim.events;

@safe:

/*
 * Event Subject Filter Decorator
 *
 * Use this decorator to allow your event listener to only
 * be invoked if event subject matches the `allowedSubject` option.
 *
 * The `allowedSubject` option can be a list of class names, if you want
 * to check multiple classes.
 */
class DSubjectFilterDecorator : DDecorator {
    /* 
    Json __invoke() {
        auto someArguments = func_get_args();
        
        return canTrigger(someArguments[0]))
            ? _call(someArguments)
            : null;
    }

    // Checks if the event is triggered for this listener.
   bool canTrigger(IEvent eventToCheck) {
        if (!_options.hasKey("allowedSubject")) {
            throw new DException(class ~ " Missing subject filter options!");
        }
        if (_options["allowedSubject"].isString) {
           _options["allowedSubject"] = [_options["allowedSubject"]];
        }
        IEventObject subject;
        try {
            subject = eventToCheck.subject();
        } catch (DException) {
            return false;
        }

        return isIn(subject.class, _options["allowedSubject"], true);
    } */
}
