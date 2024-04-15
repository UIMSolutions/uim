module uim.validations.tests.validation;

import uim.validations;

@safe:

bool testValidation(IValidation validationToTest) {
    assert(validationToTest !is null, "In testValidation: validationToTest is null");
    
    return true;
}