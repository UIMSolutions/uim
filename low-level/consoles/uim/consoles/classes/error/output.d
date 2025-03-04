/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.classes.error.output;

import uim.consoles;
@safe:

version (test_uim_consoles) {
  unittest {
      writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DErrorOutput : UIMObject, IErrorOutput {
  mixin(ErrorOutputThis!());
}

unittest {
  auto output = new DErrorOutput();
  assert(testErrorOutput(output));
}