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

string className(Object instance) {
    if (instance is null) {
        return "null";
    }

    return instance.classinfo.baseName;
}

unittest {
    class Test {
        string className;
        this() {
            className = this.className;
        }

        string cName() { return this.className; }
    }
    auto test = new Test;

    assert(test.className == "Test");
    assert(test.stringof == "test");

    class Test1 : Test {}
    class Test2 : Test1 {}

    assert((new Test1).className == "Test1");
    assert((new Test2).className == "Test2");
    writeln((new Test2).classinfo);
}