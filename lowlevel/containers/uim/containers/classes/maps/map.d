/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.containers.classes.maps.map;

mixin(Version!"test_uim_containers");

import uim.oop;
@safe:

class DMap(K, T:
    UIMObject) {
    protected T[K] _items;

    this() {
        _items = null;
    }

    void insert(K key, T value) {
        _items[K] = value;
    }

    void remove(K key) {
        _items.remove(K);
    }

    T get(K key) {
        return key in _items
            ? _items[key] : null;
    }

    bool contains(K key) {
        return (key in _items);
    }

    void clear() {
        _items.clear();
    }

    size_t length() {
        return _items.length();
    }

    void opIndexAssign(K key, T value) {
        insert(key, value);
    }

    T opIndex(K key) {
        return get(key);
    }
}

unittest {
}
