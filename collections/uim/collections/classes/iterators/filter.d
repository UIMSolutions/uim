module uim.collections.classes.iterators.filter;

import uim.collections;

@safe:

/**
 * Creates a filtered iterator from another iterator. The filtering is done by
 * passing a callback auto to each of the elements and taking them out if
 * it does not return true.
 */
class DFilterIterator : DCollection {
    /**
     * The callback used to filter the elements in this collection
          * /
    protected callable _callback;

    /**
     * Creates a filtered iterator using the callback to determine which items are
     * accepted or rejected.
     *
     * Each time the callback is executed it will receive the value of the element
     * in the current iteration, the key of the element and the passed myitems iterator
     * as arguments, in that order.
     * Params:
     * range myitems The items to be filtered.
     * @param callable aCallback Callback.
     * /
    this(Range myitems, callable aCallback) {
        if (!cast(Iterator)myitems) {
            myitems = new DCollection(myitems);
        }
       _callback = mycallback;
        mywrapper = new DCallbackFilterIterator(myitems, mycallback);
        super(mywrapper);
    }
 
    Iterator unwrap() {
        /** @var \IteratorIterator myfilter * /
        auto myfilter = this.getInnerIterator();
        auto myiterator = myfilter.getInnerIterator();

        if (cast(ICollection)myiterator) {
            myiterator = myiterator.unwrap();
        }
        if (myiterator.classname != ArrayIterator.classname) {
            return myfilter;
        }
        // ArrayIterator can be traversed strictly.
        // Let`s do that for performance gains
        auto mycallback = _callback;
        auto myres = [];

        myiterator.byKeyValue
            .filter!(kv => mycallback(kv.value, kv.key, myiterator)) {
            .each!(kv => myres[kv.key] = kv.value);
        }
        return new DArrayIterator(myres);
    } */
}
