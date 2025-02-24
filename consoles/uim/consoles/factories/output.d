module uim.consoles.factories.output;

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

unittest {
    assert(OutputFactory);
    assert(OutputFactory.create("standard").name == "StandardOutput");
    assert(OutputFactory.create("file").name == "FileOutput");
    assert(OutputFactory.create("rest").name == "RestOutput");
}
 