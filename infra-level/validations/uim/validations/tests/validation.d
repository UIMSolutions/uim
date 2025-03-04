/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.validations.tests.validation;

import uim.validations;
@safe:

version (test_uim_validations) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
} 

bool testValidation(IValidation validation) {
    assert(validation !is null, "testValidation -> validation is null");
    
    return true;
}