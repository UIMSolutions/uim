module uim.containers.classes.lists.list;

import uim.containers;

@safe:

class DList(T : UIMObject) {
    protected T[] _items;

    this() {
        _items = 0;
    }

    void pushFront(T value) {
        _items = value ~ _items;
    }

    void pushBack(T value) {
        _items ~= value;
    }

    T popFront() {
        if (_items.length == 0) {
            return null;
        }

        if (_items.length == 1) {
            T item = _items[0];
            _items = null;
            return item;
        }

        T item = _items[0];
        _items = _items[1..$];
        return item;
    }

    T popBack() {
        if (_items.length == 0) {
            return null;
        }

        if (_items.length == 1) {
            T item = _items[0];
            _items = null;
            return item;
        }

        T item = _items[$-1];
        _items = _items[0..$-1];
        return item;
    }

    T length() {
        return _items.length;
    }
}
