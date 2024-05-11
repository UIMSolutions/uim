module uim.events.classes.decorators.condition;

import uim.events;

@safe:

/**
 * Event Condition Decorator
 *
 * Use this decorator to allow your event listener to only
 * be invoked if the `if` and/or `unless` conditions pass.
 */
class DConditionDecorator : DDecorator {
    /* 
    Json __invoke() {
        someArguments = func_get_args();
        if (!this.canTrigger(someArguments[0])) {
            return null;
        }
        return _call(someArguments);
    }

    // Checks if the event is triggered for this listener.
    bool canTrigger(IEvent eventToCheck) {
        auto canIf = _evaluateCondition("if", eventToCheck);
        auto canUnless = _evaluateCondition("unless", eventToCheck);

        return  canIf && !canUnless;
    }
    
    /**
     * Evaluates the filter conditions
     *
     * @template TSubject of object
     * @param \UIM\Event\IEvent<TSubject> event Event object
     * @return bool
     */
    protected bool _evaluateCondition(string conditionType, IEvent event) {
        if (!_options.isSet(conditionType)) {
            return conditionType != "unless";
        }
        if (!_options[conditionType].isCallable) {
            throw new DInvalidArgumentException(self.class ~ " the `" ~ conditionType ~ "` condition is not a callable!");
        }
        return (bool)_options[conditionType](event);
    } */
}
