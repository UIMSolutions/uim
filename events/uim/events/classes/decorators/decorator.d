module events.uim.events.classes.decorators.decorator;

import uim.events;

@safe:

// Common base class for event decorator subclasses.
abstract class DAbstractDecorator {
    // Callable
    protected callable  _callable;

    // Decorator options
    protected array _options = [];

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
    }
}
