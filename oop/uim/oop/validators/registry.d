module uim.oop.validators.registry;

import uim.oop;
@safe:

class DValidatorRegistry : DObjectRegistry!DUIMValidator {
}
auto ValidatorRegistry() { return DValidatorRegistry.registry; }