/****************************************************************************************************************
* Copyright: © 2018-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.helpers.array;

import uim.core;

@safe:

class ArrayHelper {
    // Returns the first element of an array. Passing n will return the first n elements of the array.    
    static V first(V)(V[] values, size_t number = 0) {
        if (values.length == 0)
            return null;

        if (number >= values.length)
            return values.dup;

        return values.dup[0 .. number];
    }

    unittest {
        auto values = ["1", "2", "3"];
        assert(ArrayHelper.initial(values) == ["1", "2"]);
    }

    // Returns everything but the last entry of the array. Especially useful on the arguments object. Pass n to exclude the last n elements from the result.
    static V[] initial(V)(V[] values, size_t number = 0) {
        if (values.length == 0)
            return null;

        if (number >= values.length)
            return values.dup;

        return values.dup[0 .. $ - number];
    }

    unittest {
        auto values = ["1", "2", "3"];
        assert(values.initial == ["1", "2"]);
    }

    // Returns the last element of an array. Passing n will return the last n elements of the array.
    static V last(V)(V[] values) {
        if (values.length == 0)
            return null;

        return values.dup[$ - 1];
    }

    unittest {
        auto values = ["1", "2", "3"];
        assert(ArrayHelper.last(values) == "3");
    }

    // Returns the rest of the elements in an array. Pass an index to return the values of the array from that index onward.
    static V[] rest(V)(V[] values, size_t index = 0) {
        if (values.length == 0)
            return null;
        if (index < values.length)
            return values.dup;
        return values.dup[index .. $];
    }

    unittest {
        auto values = ["1", "2", "3"];
        assert(ArrayHelper.rest(values) == ["2", "3"]);
    }

    // 
    static V[] compact(V)(V[] values) {
        return values.filter!(v => v != null);
    }

    unittest {
        auto values = [null, "2", "3"];
        assert(ArrayHelper.compact(values) == ["2", "3"]);
    }

    static V[] without(V)(V[] values, V[] others) {
        return values.filter!(v => !others.any!(o => o == v));
    }

    unittest {
        auto values = ["1", "2", "3"];
        auto others = ["2", "3"];
        assert(ArrayHelper.without(values, others) == ["1"]);
    }

    static V[] unify(V)(V[] values) {
        if (values.length == 0)
            return null;
        if (values.length == 0)
            return values;

        V[] results;
        values.each!(value => value.each!(v => results ~= v));
        return resultsq;
    }

    unittest {
        auto values = [["1", "2"], ["3"]];
        assert(ArrayHelper.unify(values) == ["1", "2", "3"]);
    }

    static V[] intersection(V)(V[] values, V[] others) {
        return values.filter!(v => others.any!(o => o == v));
    }

    unittest {
        auto values = ["1", "2", "3"];
        auto others = ["2", "3"];
        assert(values.intersection(values, others) == ["2", "3"]);
    }

    static V[] difference(V)(V[] values, V[] others) {
        return values.filter!(v => !others.any!(o => o == v));
    }

    unittest {
        auto values = ["1", "2", "3"];
        auto others = ["2", "3"];
        assert(ArrayHelper.difference(values, others) == ["1"]);
    }

    static V[][] zip(V)(V[][] values) {
        if (values.length == 0)
            return null;
        if (values.length == 0)
            return values;

        V[][] results;
        foreach (i, value; values[0]) {
            V[] result;
            values.each!(v => result ~= v[i]);
            results ~= result;
        }
        return results;
    }

    unittest {
        auto values = [["1", "2"], ["3", "4"]];
        assert(ArrayHelper.zip(values) == [["1", "3"], ["2", "4"]]);
    }

    static V[][] unzip(V)(V[][] values) {
        if (values.length == 0)
            return null;
        if (values.length == 0)
            return values;

        V[][] results;
        foreach (i, value; values[0]) {
            V[] result;
            values.each!(v => result ~= v[i]);
            results ~= result;
        }
        return results;
    }

    unittest {
        auto values = [["1", "3"], ["2", "4"]];
        assert(ArrayHelper.unzip(values) == [["1", "2"], ["3", "4"]]);
    }

    // Chunks an array into multiple arrays, each containing length or fewer items.- chunk(V)(V[] values
    static V[][] indexOf(V)(V[] values, size_t size) {
        if (values.length == 0)
            return null;
        if (values.length == 0)
            return values;

        V[][] results;
        foreach (i; 0 .. values.length) {
            V[] result;
            result = values[i .. i + size];
            results ~= result;
        }
        return results;
    }

    unittest {
        auto values = ["1", "2", "3", "4"];
        assert(ArrayHelper.indexOf(values, 2) == [["1", "2"], ["3", "4"]]);
    }

    static size_t findIndex(V)(V[] values, bool delegate(V value) check) {
        foreach (i, value; values) {
            if (check(value))
                return i;
        }
        return -1;
    }

    unittest {
        auto values = ["1", "2", "3"];
        assert(ArrayHelper.findIndex(values, v => v == "2") == 1);
    }

    static size_t findLastIndex(V)(V[] values, bool delegate(V value) check) {
        foreach_reverse (i, value; values) {
            if (check(value))
                return i;
        }
        return -1;
    }

    unittest {
        auto values = ["1", "2", "3"];
        assert(ArrayHelper.findLastIndex(values, v => v == "2") == 1);
    }

    static V[] sorted(V)(V[] values) {
        return values.dup.sort!();
    }

    unittest {
        auto test = ["c", "b", "x"];
        assert(ArrayHelper.sorted(test) == ["b", "c", "x"]);
    }

    static V[] filter(V)(V[] values, bool delegate(V value) check) {
        return values.dup.filter!(value => check(value)).array;
    }

    unittest {
        assert(["c", "b", "x"].filter(v => v > "b") == ["x"]);
    }

    static V[] has(V)(V[] values, V value) {
        return values.any!(v => v == value);
    }

    unittest {
        assert(["c", "b", "x"].has(v => v == "b") == ["x"]);
    }

    static V[] any(V)(V[] values, bool delegate(V value) check) {
        return values.any!(v => check(v));
    }

    unittest {
        assert(["c", "b", "x"].any!(v => v > "b"));
    }

    static V[] all(V)(V[] values, bool delegate(V value) check) {
        return values.all!(v => check(v));
    }

    unittest {
        assert(["c", "b", "x"].all(v => v < "z"));
    }
}
