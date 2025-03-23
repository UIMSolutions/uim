/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.patterns.obj;

import uim.oop;
@safe:

version (test_uim_oop) {
  import std.stdio;
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class UIMObject : IObject {
    mixin TConfigurable;

    this() {
        this.initialize;
        this.name(this.classname); 
    }

    this(Json[string] initData) {
        this.initialize(initData);
        this.name(this.classname); 
    }

    this(string newName, Json[string] initData = null) {
        this.initialize(initData);
        this.name(newName);
    }

    bool initialize(Json[string] initData = null) {
        name("Object");

        auto config = MemoryConfiguration;
        configuration(config);
        configuration.set(initData);

        return true;
    }

    mixin(TProperty!("string", "name"));
    // mixin(TProperty!("string[]", "methodNames"));

    string[] memberNames() {
        return [__traits(allMembers, typeof(this))];
    }

    bool hasMember(string name) {
        return memberNames.has(name);
    }

    Json toJson(string[] showKeys = null, string[] hideKeys = null) {
        Json json = Json.emptyObject;
        json
            .set("name", name)
            .set("classname", this.classname);

        return json;
    }

    Json[string] debugInfo(string[] showKeys = null, string[] hideKeys = null) {
        Json[string] info = new Json[string];
        info
            .set("name", name)
            .set("classname", this.classname)
            .set("classFullname", this.classFullname);
        return info;
    }
}

class Test : UIMObject {
    this() {
        super();
    }
    string newMethod() {
        return null; 
    }
    override string[] memberNames() {
        return [__traits(allMembers, typeof(this))];
    }
}
unittest {
    assert(new Test);
    Test obj = new Test;
    writeln("UIMObject -> ", obj.memberNames);
    writeln("new Object -> ", (new Test).memberNames);

    writeln(obj.debugInfo().toString);
    assert(obj.debugInfo().hasAllKeys("name", "classname"));
    writeln(obj.classFullname);

/*     Test test = cast(Test)Object.factory(obj.classFullname);
    writeln(test.debugInfo().toString); */
}
