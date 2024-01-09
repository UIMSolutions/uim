module uim.core.helpers.classes;

import uim.core;

string baseName(ClassInfo classinfo) {
    string qualName = classinfo.name;

    size_t dotIndex = qualName.retro.countUntil('.');

    if (dotIndex < 0) {
        return qualName;
    }

    return qualName[($ - 4) .. $];
}

string getClassname(Object instance) {
    if (instance is null) {
        return "null";
    }

    return instance.classinfo.baseName;
}

unittest {
    class Test {}
    auto test = new Test;

    assert(test.getClassname == "Test");
    assert(test.stringof == "test");
}