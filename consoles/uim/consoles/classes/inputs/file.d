module uim.consoles.classes.inputs.file;

import uim.consoles;
@safe:

version (test_uim_consoles) {
    unittest {
        writeln("-----  ", __MODULE__, "\t  -----");
    }
}

// Object wrapper for interacting with stdin
class DFileInput : DInput {
  mixin(InputThis!("File"));
}
mixin(InputCalls!("File"));

unittest {
  auto input = FileInput;
  assert(testInput(input));
}

static this() {
    InputFactory.set("file", (Json[string] options = null) @safe {
        return new DFileInput(options);
    });
}
