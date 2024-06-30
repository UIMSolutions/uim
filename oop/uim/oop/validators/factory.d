module uim.oop.validators.factory;

import uim.oop;
@safe:

class DValidatorFactory : DFactory!DValidator {}
auto ValidatorFactory() { return DValidatorFactory.factory; }
