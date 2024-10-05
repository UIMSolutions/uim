/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.collections.classes.iterators.array;

import uim.collections;

@safe:

class DArrayIterator(T) {
    this() {
    }

    this(DArrayIterator!T iterator) {
    }

    this(T[] values) {
    }
}

auto ArrayIterator(T)() {
    return new DArrayIterator!T();
}

auto ArrayIterator(T)(DArrayIterator!T iterator) {
    return new DArrayIterator!T(iterator);
}

auto ArrayIterator(T)(T[] values) {
    return new DArrayIterator!T(values);
}
