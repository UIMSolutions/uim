module uim.oop.validators.registry;

import uim.oop;
@safe:

class DValidatorRegistry : DObjectRegistry!DValidator {
}
auto ValidatorRegistry() { return DValidatorRegistry.registry; }