/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.validations.tests.validation;import uim.validations;@safe:bool testValidation(IValidation validationToTest) {    assert(validationToTest !is null, "In testValidation: validationToTest is null");        return true;}