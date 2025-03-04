/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.patterns.obj;

import uim.oop;

@safe:

version (test_uim_oop) {
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
        Json[string] info;
        info.set("name", name).set("classname", this.classname);
        return info;
    }
}

class test : UIMObject {
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
    assert(new UIMObject);
    auto obj = new UIMObject;
    writeln("UIMObject -> ", obj.memberNames);
    writeln("new Object -> ", (new test).memberNames);
}
