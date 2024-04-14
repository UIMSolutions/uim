module uim.controllers.tests.component;

import uim.controllers; 

@safe:

bool testComponent(IComponent componentToTest) {
    assert(componentToTest !is null, "In testComponent: componentToTest is null");
    
    return true;
}