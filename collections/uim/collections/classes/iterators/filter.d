/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.collections.classes.iterators.filter;

import uim.collections;

@safe:

/**
 * Creates a filtered iterator from another iterator. The filtering is done by
 * passing a callback auto to each of the elements and taking them out if
 * it does not return true.
 */
class DFilterIterator : D_Collection {
    this() {
        super();
    }
    /**
     * The callback used to filter the elements in this collection
          * /
    protected callable _callback;

    /**
     * Creates a filtered iterator using the callback to determine which items are
     * accepted or rejected.
     *
     * Each time the callback is executed it will receive the value of the element
     * in the current iteration, the key of the element and the passed itemsToFilter iterator
     * as arguments, in that order.
     * /
    this(Json[string] itemsToFilter, callable aCallback) {
        if (!cast(Iterator)itemsToFilter) {
            itemsToFilter = new D_Collection(itemsToFilter);
        }
        _callback = mycallback;
        mywrapper = new DCallbackFilterIterator(itemsToFilter, mycallback);
        super(mywrapper);
    }
 
    Iterator unwrap() {
        auto myfilter = innerIterator();
        auto myiterator = myfilter.getInnerIterator();

        if (cast(I_Collection)myiterator) {
            myiterator = myiterator.unwrap();
        }
        if (myiterator.classname != ArrayIterator.classname) {
            return myfilter;
        }
        // ArrayIterator can be traversed strictly.
        // Let`s do that for performance gains
        auto mycallback = _callback;
        auto myres = null;

        myiterator.byKeyValue
            .filter!(kv => mycallback(kv.value, kv.key, myiterator)) {
            .each!(kv => myres.set(kv.key, kv.value);
        }
        return new DArrayIterator(myres);
    } */
}
