module uim.oop.factories.factory;

import uim.oop;

@safe:

class DFactory(T : Object) {
    this() {
    }

    protected static DFactory!T _factory;
    protected T delegate(Json[string] options = null)[string] _workers;

    public static DFactory!T factory() {
        if (_factory is null) {
            _factory = new DFactory!T;
        }
        return _factory;
    }

    void set(string workerName, T delegate(Json[string] options = null) @safe workFunc) {
        _workers[workerName] = workFunc;
    }

    T get(string workerName, Json[string] options = null) @safe {
        return workerName in _workers
            ? _workers[workerName](options) : null;
    }
    T opIndex(string workerName, Json[string] options = null) {
        return get(workerName, options);
    }

}

unittest {
    class Test {
        this() {
        }
    }

    class TestFactory : DFactory!Test {}
    auto Factory() { return TestFactory.factory; }

    Factory.set("testWorker", (Json[string] options = null) @safe {
        writeln("Name = ", options.getString("name"));
        return new Test;
    });
    Factory.set("testWorker2", (Json[string] options = null) @safe {
        writeln("testWorker2"~options.getString("name"));
        return null;
    });
    Factory.get("testWorker", ["name": Json("nam3")]);
    Factory.get("testWorker2");
    Factory["testWorker2", ["name": Json("nam3")]];
}
