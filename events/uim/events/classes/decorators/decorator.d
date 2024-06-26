module uim.events.classes.decorators.decorator;

import uim.events;

@safe:

// Common base class for event decorator subclasses.
abstract class DDecorator : IDecorator {
    // Callable
    // TODO  protected callable _callable;

    // Decorator options
    protected Json[string] _options = null;

    /* this(callable callable, Json[string] options = null) {
       _callable = callable;
       _options = options;
    } */
    
    Json __invoke() {
        // TODO return _call(func_get_args());
        return Json(null);
    }
    
    // Calls the decorated callable with the passed arguments.
    protected Json _call(Json[string] someArguments) {
/*         aCallable = _callable;

        return aCallable(...someArguments); */
        return Json(null);
    } 
}
