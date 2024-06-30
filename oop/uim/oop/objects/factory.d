module uim.oop.objects.factory;

import uim.oop;
@safe:

class DFactory(T : UIMObject) : IKeyAndPath, INamed {
    mixin TConfigurable;    
    this() {
        this.initialize;
    }

    this(Json[string] initData) {
        this.initialize(initData);
    }

    this(string newName) {
        this().name(newName);
    }

    this(string newName, Json[string] initData) {
        this(initData).name(newName);
    }

    bool initialize(Json[string] initData = null) {
        name("Attribute");

        configuration(MemoryConfiguration);
        configuration.data(initData);

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

    mixin(TProperty!("string", "name"));

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
            return keys.all!(key => hascorrectKey(key));
        }

		bool hasAnyKeys(string[] keys...) {
            return hasAnyKeys(keys.dup);
        }

		bool hasAnyKeys(string[] keys) {
            return keys.any!(key => hascorrectKey(key));
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

    T get(string[] path, Json[string] options = null) @safe {
        return get(correctKey(path), options);
    }

    T get(string key, Json[string] options = null) @safe {
        return correctedcorrectKey(key) in _workers
            ? _workers[correctedcorrectKey(key)](options) : null;
    }
    T opIndex(string key, Json[string] options = null) {
        return get(key, options);
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
            return keys.all!(key => removecorrectKey(key));
        }

		bool removeKey(string key) {
            return removeKey(correctedcorrectKey(key));
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

    assert(Factory.get("testWorkerOne").name == "one");
    assert(Factory.get(["testWorker", "two"]).name == "two");
    assert(Factory.get("testWorker.two").name == "two");
    assert(Factory.get(["testWorker", "and", "three"]).name == "three");
    assert(Factory.get("testWorker.and.three").name == "three");

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
