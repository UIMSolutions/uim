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
auto ArrayIterator(T)() { return new DArrayIterator!T(); }
auto ArrayIterator(T)(DArrayIterator!T iterator) { return new DArrayIterator!T(iterator); }
auto ArrayIterator(T)(T[] values) { return new DArrayIterator!T(values); }