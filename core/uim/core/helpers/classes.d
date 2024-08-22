module uim.core.helpers.classes;

import uim.core;
@safe:

unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}

string baseName(ClassInfo classinfo) {
    string qualName = classinfo.name;

    size_t dotIndex = qualName.retro.countUntil('.');

    if (dotIndex < 0) {
        return qualName;
    }

    return qualName[($ - dotIndex) .. $];
}

string classFullname(Object instance) {
    if (instance is null) {
        return "null";
    }

    return instance.classinfo.name;
}

string classname(Object instance) {
    if (instance is null) {
        return "null";
    }

    return instance.classinfo.baseName;
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
