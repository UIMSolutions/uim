module uim.components.tests.component;

import uim.components; 

@safe:

bool testComponent(IComponent componentToTest) {
    assert(componentToTest !is null, "In testComponent: componentToTest is null");
    
    return true;
}