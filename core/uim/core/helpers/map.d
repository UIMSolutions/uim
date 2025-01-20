module uim.core.helpers.map;

import uim.core;

@safe:

class MapHelper {
    static V[K] create(K, V)() {
        return V[K]();
    }
    unittest {
        auto items = MapHelper.create!(string, string)();
        assert(items.length == 0);
    }

    static V[K] diff(K, V)(V[K] items, V[K] otherItems) {
        auto keys = items.keys.filter!(key => key !in otherItems).array;   

        V[K] results;
        foreach (key; keys) {
            results[key] = items[key];
        }
        return results;
    }
    unittest {
        auto items = MapHelper.create!(string, string)();
        auto otherItems = MapHelper.create!(string, string)();
        items["a"] = "1";
        items["b"] = "2";
        otherItems["b"] = "2";
        otherItems["c"] = "3";
        assert(items.diff(otherItems) == ["a": "1"]);
    }

    static V[K] intersect(K, V)(V[K] items, V[K] otherItems) {
        auto keys = items.keys.filter!(key => key in otherItems).array;   

        V[K] results;
        foreach (key; keys) {
            results[key] = items[key];
        }
        return results;
    }
    unittest {
        auto items = MapHelper.create!(string, string)();
        auto otherItems = MapHelper.create!(string, string)();
        items["a"] = "1";
        items["b"] = "2";
        otherItems["b"] = "2";
        otherItems["c"] = "3";
        assert(items.intersect(otherItems) == ["b": "2"]);
    }

    static bool isEmpty(K, V)(V[K] items) {
        return (items.length == 0);   
    }
    unittest {
        auto items = MapHelper.create!(string, string)();
        assert(items.isEmpty);

        items["a"] = "1";
        assert(!items.isEmpty);
    }

    static V[K] merge(K, V)(V[K] items, V[K] otherItems) {
        V[K] results = items.dup;
        foreach (key, value; otherItems) {
            results[key] = value;
        }
        return results;
    }
    unittest {
        auto items = MapHelper.create!(string, string)();
        auto otherItems = MapHelper.create!(string, string)();
        items["a"] = "1";
        items["b"] = "2";
        otherItems["b"] = "2";
        otherItems["c"] = "3";
        assert(items.merge(otherItems) == ["a": "1", "b": "2", "c": "3"]);
    }

    static V[K] remove(K, V)(V[K] items, K[] keys) {
        V[K] results = items.dup;
        keys.each!(key => results.remove(key));
        return results;
    }	
    unittest {
        auto items = MapHelper.create!(string, string)();
        items["a"] = "1";
        items["b"] = "2";
        items["c"] = "3";
        assert(items.remove(["b", "c"]) == ["a": "1"]);
    }

    static V[K] remove(K, V)(V[K] items, K key) {
        V[K] results = items.dup;
        results.remove(key);
        return results;
    }
    unittest {
        auto items = MapHelper.create!(string, string)();
        items["a"] = "1";
        items["b"] = "2";
        assert(items.remove("b") == ["a": "1"]);
    }

    static V[K] reverse(K, V)(V[K] items) {
        V[K] results;
        foreach (key, value; items) {
            results[value] = key;
        }
        return results;
    }
    unittest {
        auto items = MapHelper.create!(string, string)();
        items["a"] = "1";
        items["b"] = "2";
        assert(items.reverse == ["1": "a", "2": "b"]);
    }

    static K[] sortedKeys(K, V)(V[K] items) {
        return items.keys.sort;
    }
    unittest {
        auto items = MapHelper.create!(string, string)();
        items["b"] = "2";
        items["a"] = "1";
        assert(items.sortedKeys == ["a", "b"]);
    }
    static K[] sortedValues(K, V)(V[K] items) {
        return items.values.sort;
    }
    unittest {
        auto items = MapHelper.create!(string, string)();
        items["b"] = "2";
        items["a"] = "1";
        assert(items.sortedValues == ["1", "2"]);
    }

    static string toString(K, V)(V[K] items) {
        return "%s".format(items);
    }
    unittest {
        auto items = MapHelper.create!(string, string)();
        items["a"] = "1";
        items["b"] = "2";
        assert(items.toString == `["a": "1", "b": "2"]`);
    }

    static V[K] update(K, V)(V[K] items, V[K] updates) {
        V[K] results = items.dup;
        updates.keys
            .filter!(key => key in items)
            .each!(key => results[k] = updates[key]);
        return results;
    }
    unittest {
        auto items = MapHelper.create!(string, string)();
        auto updates = MapHelper.create!(string, string)();
        items["a"] = "1";
        items["b"] = "2";
        updates["b"] = "3";
        updates["c"] = "4";
        assert(items.update(updates) == ["a": "1", "b": "3"]);
    }

    static V[K] update(K, V)(V[K] items, K[] keys, V value) {
        V[K] results = items.dup;
        keys
            .filter!(key => key in items)
            .each!(key => results[k] = value);
        return results;
    }
    unittest {
        auto items = MapHelper.create!(string, string)();
        items["a"] = "1";
        items["b"] = "2";
        assert(items.update(["a", "b"], "3") == ["a": "3", "b": "3"]);

        items = MapHelper.create!(string, string)();
        items["a"] = "1";
        items["b"] = "2";
        assert(items.update(["a", "b", "c"], "3") == ["a": "3", "b": "3"]);
    }
    
    static V[K] update(K, V)(V[K] items, K key, V value) {
        if (key in items) {
            V[K] results = items.dup;
            results[key] = value;
        }
        return results;
    }
    unittest {
        auto items = MapHelper.create!(string, string)();
        items["a"] = "1";
        items["b"] = "2";
        assert(items.update("b", "3") == ["a": "1", "b": "3"]);

        items = MapHelper.create!(string, string)();
        items["a"] = "1";
        items["b"] = "2";
        assert(items.update("b", "3") == ["a": "1", "b": "3"]);
        assert(items.update("c", "1") == ["a": "1", "b": "3"]);
    }
}
unittest {
    auto map = MapHelper.create!(string, string)();
}