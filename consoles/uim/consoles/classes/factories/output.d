module uim.consoles.classes.factories.output;

import uim.consoles;
@safe:

version (test_uim_consoles) {
    unittest {
        writeln("-----  ", __MODULE__, "\t  -----");
    }
}

class DOutputFactory : DFactory!DOutput{}

auto OutputFactory() {
    return DOutputFactory.factory;
}

/* static this() {
    OutputFactory.set("standard", (Json[string] options = null) @safe {
        return new DStandardOutput(options);
    });
    OutputFactory.set("file", (Json[string] options = null) @safe {
        return new DFileOutput(options);
    });
    OutputFactory.set("rest", (Json[string] options = null) @safe {
        return new DRestOutput(options);
    });
}

unittest {
    assert(OutputFactory);
    assert(OutputFactory.create("standard").name == "StandardOutput");
    assert(OutputFactory.create("file").name == "FileOutput");
    assert(OutputFactory.create("rest").name == "RestOutput");
}
 */