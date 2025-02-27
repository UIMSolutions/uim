/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.patterns.factory;

import uim.oop;
@safe:

version (test_uim_oop) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DFactory(T : UIMObject) : UIMObject, IKeyAndPath {
    this() {
        super();
    }

    this(Json[string] initData) {
        super(initData);
    }

    this(string newName, Json[string] initData = null) {
        super(newName, initData);
    }

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return true;
        }

        name("Attribute");

        return true;
    }

    protected static DFactory!T _factory;
    protected T delegate(Json[string] options = null)[string] _workers;
    public static DFactory!T factory() {
        if (_factory is null) {
            _factory = new DFactory!T;
        }
        return _factory;
    }

    protected string _pathSeparator = ".";

    // #region paths
    string[][] paths() {
            return _workers.keys.map!(key => key.split(_pathSeparator)).array;
        }

    bool hasAllPaths(string[][] paths) {
            return paths.all!(path => hasPath(path));
        }

    bool hasAnyPaths(string[][] paths) {
            return paths.any!(path => hasPath(path));
        }
        
        bool hasPath(string[] path) {
            return hasKey(path.join(_pathSeparator));
        }
  // #endregion paths

    // #region keys
    string[] keys() {
            return _workers.keys;
        }

    bool hasAllKeys(string[] keys...) {
            return hasAllKeys(keys.dup);
        }

    bool hasAllKeys(string[] keys) {
            return keys.all!(key => hasKey(key));
        }

    bool hasAnyKeys(string[] keys...) {
            return hasAnyKeys(keys.dup);
        }

    bool hasAnyKeys(string[] keys) {
            return keys.any!(key => hasKey(key));
        }

    bool hasKey(string key) {
            return key in _workers ? true : false;
        }

        string correctKey(string[] path) {
            return correctKey(path.join(_pathSeparator));
        }

        string correctKey(string key) {
            return key.strip;
        }
  // #endregion keys

    void set(string workerName, T delegate(Json[string] options = null) @safe workFunc) {
        _workers[workerName] = workFunc;
    }

    T path(string[] path, Json[string] options = null) @safe {
        return create(correctKey(path), options);
    }

    T create(string key, Json[string] options = null) @safe {
        return correctKey(key) in _workers
            ? _workers[correctKey(key)](options) : null;
    }
    T opIndex(string key, Json[string] options = null) {
        return create(key, options);
    }

    // #region remove
    bool removePaths(string[][] paths) {
            return paths.all!(path => removePath(path));
        }

    bool removePath(string[] path) {
            return removeKey(correctKey(path));
        }

    bool removeKeys(string[] keys...) {
            return removeKeys(keys.dup);
        }

    bool removeKeys(string[] keys) {
            return keys.all!(key => removeKey(key));
        }

    bool removeKey(string key) {
            return removeKey(correctKey(key));
        } 

    void clear() {
            _workers = null; 
        }
  // #endregion remove
}

unittest {
    class Test : UIMObject {
        this() {
            this.name("Test");
        }
        this(string name) {
            this().name(name);
        }
    }

    class TestFactory : DFactory!Test {}
    auto Factory() { return TestFactory.factory; }

    Factory.set("testWorkerOne", (Json[string] options = null) @safe {
        return new Test("one");
    });
    Factory.set("testWorker.two", (Json[string] options = null) @safe {        
        return new Test("two");
    });
    Factory.set("testWorker.and.three", (Json[string] options = null) @safe {        
        return new Test("three");
    });

    assert(Factory.create("testWorkerOne").name == "one");
    assert(Factory.path(["testWorker", "two"]).name == "two");
    assert(Factory.create("testWorker.two").name == "two");
    assert(Factory.path(["testWorker", "and", "three"]).name == "three");
    assert(Factory.create("testWorker.and.three").name == "three");

    assert(Factory.hasPath(["testWorkerOne"]));
    assert(Factory.hasKey("testWorkerOne"));

    assert(Factory.hasPath(["testWorker", "two"]));
    assert(Factory.hasKey("testWorker.two"));

    assert(Factory.hasPath(["testWorker", "and", "three"]));
    assert(Factory.hasKey("testWorker.and.three"));

    assert(Factory.hasAnyPaths([["testWorker", "two"], ["unknown"]]));
    assert(Factory.hasAllPaths([["testWorker", "two"], ["testWorker", "and", "three"]]));

    assert(Factory.hasAnyKeys("testWorker.two", "unknown"));
    assert(Factory.hasAnyKeys(["testWorker.two", "unknown"]));
    assert(Factory.hasAllKeys("testWorker.two", "testWorkerOne"));
    assert(Factory.hasAllKeys(["testWorker.two", "testWorkerOne"]));
}
