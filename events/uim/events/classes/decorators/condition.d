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
    override Json __invoke() {
        /* auto someArguments = func_get_args();
        return canTrigger(someArguments[0])
            ? _call(someArguments) 
            : Json(null); */
            return Json(null);
    }

    // Checks if the event is triggered for this listener.
    bool canTrigger(IEvent eventToCheck) {
        auto canIf = _evaluateCondition("if", eventToCheck);
        auto canUnless = _evaluateCondition("unless", eventToCheck);

        return canIf && !canUnless;
    }

    // Evaluates the filter conditions
    protected bool _evaluateCondition(string conditionType, IEvent event) {
/*         if (!_options.hasKey(conditionType)) {
            return conditionType != "unless";
        }

        if (!_options[conditionType].isCallable) {
            throw new DInvalidArgumentException(
                this.classname ~ " the `" ~ conditionType ~ "` condition is not a callable!");
        }
        
        return _options[conditionType].getBool(event); */
        return false; 
    }
}
