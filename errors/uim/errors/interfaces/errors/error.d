
/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.errors.interfaces.errors.error;

import uim.errors;
@safe:

version (test_uim_errors) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

interface IError {
    ERRORS code(); 

    string label(); 
    string line(); 
    string message(); 

    string fileName(); 

    size_t lineNumber(); 

    size_t[string][] trace(); 
        string traceAsString(); 

}
