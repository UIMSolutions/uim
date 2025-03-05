/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.classes.error.rest;

import uim.consoles;
@safe:

version (test_uim_consoles) {
  unittest {
      writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DRestErrorOutput : DErrorOutput {
  mixin(ErrorOutputThis!("Rest"));
}
mixin(ErrorOutputCalls!("Rest"));

unittest {
  auto output = RestErrorOutput();   
  assert(testErrorOutput(output));

  assert(output.name == "RestErrorOutput");
}