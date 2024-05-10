module uim.models.tests.attribute;

import uim.models;

@safe:

bool testAttribute(IAttribute attributeToTest) {
    assert(attributeToTest !is null, "In testAttribute: attributeToTest is null");
    
    return true;
}