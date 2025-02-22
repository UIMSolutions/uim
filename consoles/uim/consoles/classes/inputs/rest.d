module uim.consoles.classes.inputs.rest;

import uim.consoles;
@safe:

version (test_uim_consoles) {
    unittest {
        writeln("-----  ", __MODULE__, "\t  -----");
    }
}

// Object wrapper for interacting with stdin
class DRestInput : DInput {
  mixin(InputThis!("Rest"));
}
mixin(InputCalls!("Rest"));

unittest {
  auto input = RestInput;
  assert(testInput(input));
}
