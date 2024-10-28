/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.helpers.classes;

import uim.core;

@safe:

unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
}

string baseName(ClassInfo classinfo) {
    string qualName = classinfo.name;
    size_t dotIndex = qualName.retro.countUntil('.');

    return dotIndex < 0
        ? qualName : qualName[($ - dotIndex) .. $];
}

string classFullname(Object instance) {
    return instance is null
        ? "null" : instance.classinfo.name;
}

string classname(Object instance) {
    return instance is null
        ? null : instance.classinfo.baseName;
}

unittest {
    interface ITest {
        O create(this O)();
    };

    class Test : ITest {
        O create(this O)() {
            return cast(O) this.classinfo.create;
        }
    }

    auto test = new Test;
    writeln("test.classname", test.classname);
    assert(test.classname == "Test");
    assert(test.stringof == "test");

    class Test1 : Test {

    }

    class Test2 : Test1 {
    }

    assert((new Test1).classname == "Test1");
    assert((new Test2).classname == "Test2");

    writeln((new Test2).classinfo);
    writeln("Base:", (new Test2).classinfo.base);
    writeln("Name:", (new Test2).classinfo.name);
    writeln("classname:", (new Test2).classname);
    writeln("fullclassname:", (new Test2).classFullname);
    writeln("Interfaces:", (new Test).classinfo.interfaces);

    Object result;
    Test2 function(string) fn;
    string name = "uim.core.helpers.classes.tt";
    () @trusted { result = Object.factory(name); }();
    debug writeln(result.classname);
    /* debug writeln(x("uim.core.helpers.classes.tt"));*/
    debug writeln((new Test2).classinfo.create);
    auto cl = (new Test2).classinfo;
    debug writeln(cl.create);

    debug writeln((new Test2).create);
}
