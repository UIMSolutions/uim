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
    interface ITest{
                O create(this O)();
    };

    class Test : ITest {
                O create(this O)() {
            return cast(O)this.classinfo.create;
        }
    }
    auto test = new Test;
    assert(test.className == "Test");
    assert(test.stringof == "test");

    class Test1 : Test {

    }
    class Test2 : Test1 {
    }

    assert((new Test1).className == "Test1");
    assert((new Test2).className == "Test2");
    
    writeln((new Test2).classinfo);
    writeln("Base:", (new Test2).classinfo.base);
    writeln("Name:", (new Test2).classinfo.name);
    writeln("ClassName:", (new Test2).className);
    writeln("fullClassname:", (new Test2).classFullname);
    writeln("Interfaces:", (new Test).classinfo.interfaces);

    Object result;
    Test2 function(string) fn;
    string name = "uim.core.helpers.classes.tt";
    () @trusted { result = Object.factory(name); }();
    debug writeln(result.className);
    /* debug writeln(x("uim.core.helpers.classes.tt"));*/
    debug writeln((new Test2).classinfo.create); 
    auto cl = (new Test2).classinfo;
    debug writeln(cl.create);

    debug writeln((new Test2).create);
}