module uim.events.tests.decorator;

import uim.events;

@safe:

bool testDecorator(IDecorator decoratorToTest) {
    assert(decoratorToTest !is null, "In testDecorator: decoratorToTest is null");
    
    return true;
}