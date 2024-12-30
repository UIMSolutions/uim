module uim.consoles.classes.outputs.factory;

import uim.consoles;

@safe:

class DOutputFactory : DFactory!DOutput{}

auto OutputFactory() {
    return DOutputFactory.factory;
}

unittest {
    assert(OutputFactory);
    assert(OutputFactory.get("standard"));
}

static this() {
    OutputFactory.set("standard", (Json[string] options = null) @safe {
        return new DStandardOutput(options);
    });
}