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
  string code();
  IError code(string newCode);

  string label();
  string line();

  string message();
  IError message(string newMessage);

  string fileName();
  IError fileName(string newFileName);

  size_t lineNumber();
  IError lineNumber(size_t newLineNumber);

  STRINGAA[] trace();
  IError trace(STRINGAA[] newTrace);
  string traceAsString();
}
