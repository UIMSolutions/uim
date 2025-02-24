module uim.consoles.classes.factories.input;

import uim.consoles;
@safe:

version (test_uim_consoles) {
    unittest {
        writeln("-----  ", __MODULE__, "\t  -----");
    }
}

class DInputFactory : DFactory!DInput{}

auto InputFactory() {
    return DInputFactory.factory;
}

/* unittest {
    assert(InputFactory);
    assert(InputFactory.create("standard").name == "StandardInput");
    assert(InputFactory.create("file").name == "FileInput");
    assert(InputFactory.create("rest").name == "RestInput");
}
 */