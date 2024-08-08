module uim.oop.validators.factory;

import uim.oop;
@safe:

class DValidatorFactory : DFactory!DUIMValidator {}
auto ValidatorFactory() { return DValidatorFactory.factory; }
