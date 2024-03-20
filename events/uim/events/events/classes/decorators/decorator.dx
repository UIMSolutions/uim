module uim.events.event.decorators.decorator;

import uim.events;

@safe:

// Common base class for event decorator subclasses.
abstract class AbstractDecorator {
    // Callable
    protected callable  _callable;

    // Decorator options
    protected array _options = [];

    this(callable callable, IData[string] options = null) {
       _callable = callable;
       _options = options;
    }
    
    Json __invoke() {
        return _call(func_get_args());
    }
    
    // Calls the decorated callable with the passed arguments.
    protected Json _call(array someArguments) {
        aCallable = _callable;

        return aCallable(...someArguments);
    }
}
