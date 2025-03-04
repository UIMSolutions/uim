/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.consoles.classes.error.standard;

import uim.consoles;
@safe:

version (test_uim_consoles) {
  unittest {
      writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DStandardErrorOutput : DErrorOutput {
  mixin(ErrorOutputThis!("Standard"));
}
mixin(ErrorOutputCalls!("Standard"));

unittest {
  auto output = StandardErrorOutput();
  assert(testErrorOutput(output));

  assert(output.name == "StandardErrorOutput");
}