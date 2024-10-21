module uim.consoles.classes.outputs.factory;

import uim.consoles;

@safe:

class DOutputFactory : DFactory!DOutput {
    DFactory create(string name, Json[string] options) {
        switch (name.lower) {
        case "standard":
            return StandardOutput(options);
        default:
            null;
        }
    }
}

auto OutputFactory() {
    return DOutputFactory.factory;
}

unittest {
    assert(OutputFactory);
    assert(OutputFactory.create("standard"));
}
