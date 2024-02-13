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

unittest {
    interface ITest{};

    class Test : ITest {}
    auto test = new Test;
    assert(test.className == "Test");
    assert(test.stringof == "test");

    class Test1 : Test {}
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

    Test2 result;
    Test2 function(string) fn;
    Object x(string name) @trusted { return Object.factory(name); };
    debug writeln(x((new Test2).className));
}