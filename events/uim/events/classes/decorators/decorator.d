module uim.events.classes.decorators.decorator;

import uim.events;

@safe:

// Common base class for event decorator subclasses.
abstract class DDecorator : IDecorator {
    /* 
    // Callable
    protected callable  _callable;

    // Decorator options
    // TODO protected array _options = null;

    this(callable callable, IData[string] options = null) {
       _callable = callable;
       _options = options;
    }
    
    IData __invoke() {
        return _call(func_get_args());
    }
    
    // Calls the decorated callable with the passed arguments.
    protected IData _call(array someArguments) {
        aCallable = _callable;

        return aCallable(...someArguments);
    } */
}
