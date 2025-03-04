/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.patterns.collection;

import uim.oop;

@safe:

class DCollection(T : UIMObject) : UIMObject, IKeyAndPath, ICollection!T {
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

    protected string _pathSeparator = ".";
    protected T[string] _items;

    size_t count() {
        return _items.length;
    }

    // #region paths
    string[][] paths() {
        return _items.keys.map!(key => key.split(_pathSeparator)).array;
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
        return _items.keys;
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
        return key in _items ? true : false;
    }

    string correctKey(string[] path) {
        return correctKey(path.join(_pathSeparator));
    }

    string correctKey(string key) {
        return key.strip;
    }
    // #endregion keys

    // #region items
        T[] items() {
            return _items.values;
        }

        bool hasAnyItems(T[] items) {
            return items.any!(obj => hasItem(obj));
        }

        bool hasAllItems(T[] items) {
            return items.all!(obj => hasItem(obj));
        }

        bool hasItem(T item) {
            foreach (obj; _items.values) {
                // if (obj.isEquals(item)) { return true; }
            }
            return false;
        }
    // #endregion items

    // #region getter
        T get(string[] path) {
            return get(path.join(_pathSeparator));
        }

        T opIndex(string key) {
            return get(key);
        }

        T get(string key) {
            return key in _items ? _items[key] : null;
        }
    // #endregion getter

    // #region setter
        O set(this o)(T[string] newItems) {
            newItems.byKeyValue.each!(kv => set(kv.key, kv.value));
            return cast(O) this;
        }

        O set(this o)(string[] path, T newItem) {
            set(path.join(_pathSeparator), newItem);
            return cast(O) this;
        }

        void opIndexAssign(string key, T newItem) {
            set(key, newItem);
        }

        O set(this O)(string key, T newItem) {
            _items[key] = newItem;
            return cast(O) this;
        }
    // #endregion setter

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
            _items = null;
        }
    // #endregion remove
}
