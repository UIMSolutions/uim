module uim.core.helpers.classes;

import uim.core;

string baseName(ClassInfo classinfo) {
    string qualName = classinfo.name;

    size_t dotIndex = qualName.retro.countUntil('.');

    if (dotIndex < 0) {
        return qualName;
    }

    return qualName[($ - dotIndex) .. $];
}

string getClassname(Object instance) {
    if (instance is null) {
        return "null";
    }

    return instance.classinfo.baseName;
}

unittest {
    class Test {
        string className;
        this() {
            className = this.getClassname;
        }

        string cName() { return this.getClassname; }
    }
    auto test = new Test;

    assert(test.getClassname == "Test");
    assert(test.stringof == "test");

    class Test1 : Test {}
    class Test2 : Test1 {}

    assert((new Test1).getClassname == "Test1");
    assert((new Test2).getClassname == "Test2");
    writeln((new Test2).classinfo);
}