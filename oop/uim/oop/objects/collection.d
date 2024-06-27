module uim.oop.objects.collection;

import uim.oop;

@safe:

class DCollection(T : UIMObject) : UIMObject, IKeyAndPath, INamed {
    this() {
        super("Collection");
    }

    this(Json[string] initData) {
        super("Collection", initData);
    }

    this(string newName, Json[string] initData = null) {
        this(initData).name(newName);
    }

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    protected T[string] objects;

    // #region keys
    string[] keys() {
        return _objects.keys;
    }

    bool hasAnyPaths(string[][] paths) {
        return paths.any!(path => hasPath(path));
    }

    bool hasAllPaths(string[][] paths) {
        return paths.all!(path => hasPath(path));
    }

    bool hasPath(string[] path) {
        return _objects.hasKey(path.join(_pathSeparator));
    }

    bool hasAllKeys(string[] keys) {
        return keys.all!(key => hasKey(key));
    }

    bool hasAnyKeys(string[] keys) {
        return keys.any!(key => hasKey(key));
    }

    bool hasKey(string key) {
        return _objects.hasKey(key);
    }
    // #endregion keys

    // #region objects
    T[] objects() {
        return _objects.values;
    }

    bool hasAnyObjects(T[] objects) {
        return objects.any!(obj => hasObject(obj));
    }

    bool hasAllObjects(T[] objects) {
        return objects.all!(obj => hasObject(obj));
    }

    bool hasObject(T object) {
        foreach (obj; _objects.values) {
            // if (obj.isEquals(object)) { return true; }
        }
        return false;
    }

    T get(string[] path) {
        return get(path.join(_pathSeparator));
    }

    T opIndex(string key) {
        return get(key);
    }

    T get(string key) {
        return _objects.get(key, _nullValue);
    }
    // #endregion objects

    // #region setter
    O set(this o)(T[string] newObjects) {
        newObjects.byKeyValue.each!(kv => set(kv.key, kv.value));
        return cast(O) this;
    }

    O set(this o)(string[] path, T newObject) {
        set(path.join(_pathSeparator), newObject);
        return cast(O) this;
    }

    void opIndexAssign(string key, T newObject) {
        set(key, newObject);
    }

    O set(this O)(string key, T newObject) {
        _objects[key] = newObject;
        return cast(O) this;
    }
    // #endregion setter

    // #region remove
    bool remove(string[] keys) {
        return keys.all!(reg => remove(reg));
    }

    bool remove(string key) {
        return _objects.remove(key);
    }

    void clear() {
        _objects = null;
    }
    // #endregion remove
}
