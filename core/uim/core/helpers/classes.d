module uim.core.helpers.classes;

import uim.core;

@safe:

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

string className(Object instance) {
    if (instance is null) {
        return "null";
    }

    return instance.classinfo.baseName;
}

class tt() {

}

unittest {
    interface ITest {
        O create(this O)();
    };

    class DTest : ITest {
        O create(this O)() {
            return cast(O) this.classinfo.create;
        }
    }

    auto test = new DTest;
    assert(test.className == "Test");
    assert(test.stringof == "test");

    class DTest1 : DTest {

    }

    class DTest2 : DTest1 {
    }

    assert((new DTest1).className == "Test1");
    assert((new DTest2).className == "Test2");

    writeln((new DTest2).classinfo);
    writeln("Base:", (new DTest2).classinfo.base);
    writeln("Name:", (new DTest2).classinfo.name);
    writeln("ClassName:", (new DTest2).className);
    writeln("fullClassname:", (new DTest2).classFullname);
    writeln("Interfaces:", (new DTest).classinfo.interfaces);

    Object result;
    DTest2 function(string) fn;
    string name = "uim.core.helpers.classes.tt";
    () @trusted { result = Object.factory(name); }();
    debug writeln(result.className);
    /* debug writeln(x("uim.core.helpers.classes.tt"));*/
    debug writeln((new DTest2).classinfo.create);
    auto cl = (new DTest2).classinfo;
    debug writeln(cl.create);

    debug writeln((new DTest2).create);
}
