module uim.consoles.factories.error;

import uim.consoles;
@safe:

version (test_uim_consoles) {
    unittest {
        writeln("-----  ", __MODULE__, "\t  -----");
    }
}

class DErrorOutputFactory : DFactory!DErrorOutput{}

auto ErrorOutputFactory() {
    return DErrorOutputFactory.factory;
}

unittest {
    assert(ErrorOutputFactory);
    assert(ErrorOutputFactory.create("standard").name == "StandardErrorOutput");
    assert(ErrorOutputFactory.create("file").name == "FileErrorOutput");
    assert(ErrorOutputFactory.create("rest").name == "RestErrorOutput");
}


